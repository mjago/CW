# encoding: utf-8

#require 'wavefile'
require 'coreaudio'

module CWG

  class Read

    TONE_400_BIN_NARROW =  0
    TONE_400_BIN_WIDE =  1
    TONE_450_BIN_NARROW =  2
    TONE_450_BIN_WIDE =  3
    TONE_500_BIN_NARROW =  4
    TONE_500_BIN_WIDE =  5
    TONE_550_BIN_NARROW =  6
    TONE_550_BIN_WIDE =  7
    TONE_600_BIN_NARROW =  8
    TONE_600_BIN_WIDE =  9
    TONE_700_BIN_NARROW =  10
    TONE_700_BIN_WIDE =  11
    TONE_800_BIN_NARROW =  12
    TONE_800_BIN_WIDE =  13
    TONE_900_BIN_NARROW =  14
    TONE_900_BIN_WIDE =  15
    TONE_1000_BIN_NARROW =  16
    TONE_1000_BIN_WIDE =  17
    TONE_500_BIN_V_NARROW =  18

    SOUND_CARD_RATE = 44100
    SAMPLING_DIVISOR = 1
    TONE_WIDTH    = 12
    SAMPLING_FREQ = SOUND_CARD_RATE / SAMPLING_DIVISOR
    DATA = [
      {tone: 400, bin_width: 40},
      {tone: 400, bin_width: 80},
      {tone: 450, bin_width: 45},
      {tone: 450, bin_width: 90},
      {tone: 500, bin_width: 200},
      {tone: 500, bin_width: 400},
      {tone: 550, bin_width: 55},
      {tone: 550, bin_width: 110},
      {tone: 600, bin_width: 60},
      {tone: 600, bin_width: 120},
      {tone: 700, bin_width: 70},
      {tone: 700, bin_width: 140},
      {tone: 800, bin_width: 80},
      {tone: 800, bin_width: 160},
      {tone: 900, bin_width: 90},
      {tone: 900, bin_width: 180},
      {tone: 1000, bin_width: 100},
      {tone: 1000, bin_width: 200},
      {tone: 500, bin_width: 100},
    ]
    def n(x) ; @sample_rate / DATA[x][:bin_width] * SAMPLING_DIVISOR ; end
    def k(x) ; (0.5 + ((n(x) * DATA[x][:tone] / @sample_rate))).to_i ; end
    def w(x) ; ((2 * Math::PI) / n(x)) * k(x) ; end
    def cosine(x) ; Math.cos(w(x)) ; end
    def coeff(x) ; 2 * cosine(x) ; end
    def millis ; @millisecs; end
    def n_delay_ms(x) ; ((1.0/SOUND_CARD_RATE) * n(x) * 1000); end
    def print ; @print ||= Print.new ; end

    def initialize(filename)
      @mag_max = 0
      @mag_min = 999999999
      @sample_rate = SAMPLING_FREQ
      @n_val, @coeff, @n_delay_ms = [], [], []
      [TONE_500_BIN_WIDE,
       TONE_500_BIN_NARROW,
       TONE_500_BIN_V_NARROW,
      ].each_with_index do |width,idx|
        @n_val[idx] = n(width)
        @coeff[idx] = coeff(width)
        @n_delay_ms[idx] = n_delay_ms(width)
      end
      reset_width
      @filename = filename
      @code = []
      @cw_encoding = CwEncoding.new
      @q1 = 0
      @q2 = 0
      #      @magnitudelimit = 500000
      @magnitudelimit = 1000
      @magnitudelimit_low = @magnitudelimit
      @wpm = 15
      @real_state = false
      @filtered_state = false
      @real_state_store = false
      @filtered_state_store = false
      @awaiting_space = false
      @start_time = 0.0
      @noise_blanking_period = 6
      @start_time_high = 0
      @high_period = 0
      @high_period_store = 0
      @high_period_avg = 0
      @start_time_low = 0
      @low_period = 0
      @last_start_time = 0
      @millisecs = 0
      @last_print = 0
      @last = 0
      @queue = Queue.new
      puts "@n_val  #{@n_val[@width]}"
      input
    end

    def open_sound_device
      soundflower = nil
      CoreAudio.devices.each do |device|
        if device.name == 'Soundflower (2ch)'
          soundflower = device
        end
      end
      @buf_in = soundflower.input_buffer(44100)
      @buf_in.start
    end

    def input
      startup = 0
      open_sound_device
      nval = @n_val[@width]
      nval8 = nval * 8
      loop do
        bufs = @buf_in.read(nval8)
        count = 0
        8.times do
          nval.times do
            update_coeffs_per_sample(bufs[count] + bufs[count + 1])
            count += 2
          end
          @millisecs += @n_delay_ms[@width]

          per_block_processing
          magnitude_filter
          calc_real_state
          calc_filtered_state
          if startup > 64
            decode_signal
          end
          startup += 1
          store_high_period
          store_filtered_state
          reset_width if @millisecs > (@last_print + 5000)
        end
      end
      @buf_in.stop
      $stdout.puts "done."
    end

    def magnitude_test
      soundflower = nil
      CoreAudio.devices.each do |device|
        if device.name == 'Soundflower (2ch)'
          soundflower = device
        end
      end

      @buf_in = soundflower.input_buffer(44100)

      #      soundflower = CoreAudio.default_input_device
      #      puts "device: #{soundflower}"
      #      $stdout.print "Listening...\n"
      #      $stdout.flush
      #      @dev_out = CoreAudio.default_output_device
      #      @buf = @dev_out.output_buffer(1024)

      thr_in = Thread.fork do
        @buf_in.start
        loop do
          process_frame
          @millisecs += @n_delay_ms[@width]
          #          dbg_print "  @n_val: #{@n_val}\n  " +
          #                    "@sample_rate: #{@sample_rate}\n  " +
          #                    "@millisecs: #{@millisecs}\n  @n_delay_ms: #{@n_delay_ms}"
          per_block_processing
          magnitude_filter
          calc_real_state
          calc_filtered_state
          decode_signal
          store_high_period
          store_filtered_state
        end
      end

      @dev_out = CoreAudio.default_output_device
      @buf_out = @dev_out.output_buffer(1024)
#      @out_file = File.new("high_res_v_narrow.txt",'w+')
      (0..1000).step(2) do |x|
        puts "Freq: #{x}"
        thr_out = Thread.fork do
          generate_sinewave x.to_f
          thr_out.kill
        end
        thr_out.join
      end
#      @out_file.close
      thr_in.kill.join
      @buf_out.stop
      puts "#{@buf_out.dropped_frame} frame dropped."
      @buf_in.stop
      $stdout.puts "done."
    end

    def generate_sinewave freq

      @phase = Math::PI * 2.0 * freq / @dev_out.nominal_rate
      int_freq = freq.to_i
      i = 0
      @wav = NArray.sint(int_freq)
      @buf_out.start
      (int_freq/4).times do
        (int_freq).times {|j| @wav[j] = (0.4 * Math.sin(@phase*(i+j)) * 0x7FFF).round }
        i += (int_freq)
        @buf_out << @wav
      end
      puts "  Max: #{(@mag_max / 1000000.0).round(3)}"
#      @out_file.print "#{(@mag_max / 1000000.0).round(3)},"
      @mag_max = 0
    end

    def dbg_print message
      if @millisecs > @last
        @last = @millisecs + 5000
        puts
        puts "  " + message
        @mag_min = 999999999
        @mag_max = 0
      end
    end

    def calc_magnitude q1, q2
      magnitude_squared = (q1 * q1) + (q2 * q2) - (q1 * q2 * @coeff[@width])
      @magnitude = magnitude_squared.to_i
      @magnitude = Math.sqrt(magnitude_squared).to_i;
#            p @magnitude
    end

    def per_block_processing
      magnitude_squared = (@q1 * @q1) + (@q2 * @q2) - (@q1 * @q2 * @coeff[@width])
      @magnitude = magnitude_squared.to_i
      @magnitude = Math.sqrt(magnitude_squared).to_i;
      @q1, @q2 = 0, 0;
      #      p @magnitude
    end

    def magnitude_filter
      if(@magnitude > @magnitudelimit_low)
        @magnitudelimit = (@magnitudelimit + ((@magnitude - @magnitudelimit) / 6))  # moving average filter
      else
        @magnitudelimit = @magnitudelimit_low
      end
      #      dbg_print "@magnitude: #{@magnitude.to_s}\n  @magnitudelimit: #{@magnitudelimit.to_s}\n  @magnitudelimit_low = #{@magnitudelimit_low}"

      @mag_max = @magnitude if @magnitude > @mag_max
      @mag_min = @magnitude if @magnitude < @mag_min

      #      dbg_print "@magnitude: #{@magnitude.to_s}\n" +
      #                "  @mag_max: #{@mag_max.to_s}\n" +
      #                "  @mag_min: #{@mag_min.to_s}\n"
    end

    def calc_real_state
      @real_state =
        (@magnitude > (@magnitudelimit * 0.6)) ?
          true : false
    end

    def calc_filtered_state
      if real_state_change?
        reset_last_start_time
      end

#        puts @millisecs
      if((millis() - @last_start_time) > @noise_blanking_period)
        @filtered_state = @real_state
      end

      if filtered_state_change?
        if(@filtered_state == true)
          @start_time_high = millis()
          @low_period = (millis() - @start_time_low)
        else
#          $stdout.print '-'
          @start_time_low = millis();
          @high_period = (millis() - @start_time_high);
          if((@high_period < (2 * @high_period_avg)) || (@high_period_avg == 0))
            @high_period_avg = (@high_period + @high_period_avg + @high_period_avg) / 3  # now we know avg dit time ( rolling 3 avg)
          end

          if(@high_period > (5 * @high_period_avg))
            @high_period_avg = @high_period + @high_period_avg;     # if speed decrease fast ..
          end
        end
      end
      store_real_state
    end

    def decode_signal
      if(filtered_state_change?)
        if(@filtered_state == false) #  we did end a HIGH
          @awaiting_space = true
          if timing_match?(@high_period, 0.6, 2)
            #  0.6 filter out false dits
            @code << :dot
#            $stdout.print '.'

#            @out_file.print "#{@high_period_avg},"
          end
          if timing_match?(@high_period, 2, 6)
            @code << :dash
#            $stdout.print '_'
            #           puts 'dash'
            @wpm = (@wpm + (1200/((@high_period)/3)))/2;  # the most precise we can do ;o)
            # dbg_print "wpm #{@wpm.round(1)}"
          end
        else # we did end a LOW
          if timing_match?(@low_period, 2.0, 5) # letter space
            @low_period = @millisecs - @low_period
            print_char
          end
        end
      end
      return unless @awaiting_space
      if timing_match?((@millisecs - @start_time_low), 6.0, 7.0)
#      if((millis() - @start_time_low) >= (@high_period_avg * 5.8)) # word space
        print_char unless @code == []
        print_space
        @awaiting_space = false
      end
    end

    def timing_match?(period, avg_x_low, avg_x_high)
      ((period < (@high_period_avg * avg_x_high)) &&
       (period > (@high_period_avg * avg_x_low)))
    end

    def print_space
      @code = [:space]
      print_char
    end

    def update_coeffs_per_sample(data)
      q0 = @coeff[@width] * @q1 - @q2 + data
      #      dbg_print "  @k: #{@k}\n  @cosine: #{@cosine}\n  @coeff: #{@coeff}\n  q0: #{q0}\n"
      @q2, @q1 = @q1, q0
    end

    def reset_last_start_time
      @last_start_time = millis()
    end

    def real_state_change?
#      if @real_state != @real_state_store
#        $stdout.print 'hi' if @real_state == true
#        $stdout.print 'low' if @real_state == false
#      end
      @real_state != @real_state_store
    end

    def filtered_state_change?
      @filtered_state != @filtered_state_store
    end

    def store_high_period
      @high_period_store = @high_period
    end

    def store_real_state
      @real_state_store = @real_state
    end

    def store_filtered_state
      @filtered_state_store = @filtered_state
    end

    def matched_char
      @cw_encoding.fetch_char @code
    end

    def reset_width
      @print_success = 0
      @width = 0
      @last_print = @millisecs
    end

    def print_char
      char = matched_char
      if char == ''
        reset_width
        #        @wpm -= 5
        @low_period = 0
        @high_period = 0
        @real_state = false
        @filtered_state = false
        @real_state_store = false
        @filtered_state_store = false
        @awaiting_space = false
        @start_time = 0.0
        @noise_blanking_period = 0
        @start_time_high = 0
        @high_period = 0
        @high_period_store = 0
        @high_period_avg = 0
        @start_time_low = 0
        @low_period = 0
        @last_start_time = 0
        @millisecs = 0
        @last = 0
      else
        @last_print = @millisecs
        @print_success += 1
        @width = 1 if @print_success == 20
        @high_period_avg *= 2 if @print_success == 20
        @width = 2 if @print_success == 40
        @high_period_avg *= 2 if @print_success == 40
        print.speculative char if @print_success <= 20
        print.stable char if @print_success > 20 && @print_success <= 40
        print.optimum char if @print_success > 40
      end
      @code = []
    end

    def sample
      loop_count = 0
      @testData = Array.new(@n_val[@width])
      WaveFile::Reader.new(@filename).each_buffer(SAMPLE_FRAMES_PER_BUFFER) do |buffer|
        #        p buffer
        #        exit
        loop do
          done = false
          count = 0
          @n_val[@width].times do
            length = buffer.samples.length
            done = true unless(length > 0)
            #@millisecs += 0.43405
            @millisecs += 1
            @testData[count] = (buffer.samples.shift) unless done # + 32768
            @testData[count] = 0 if done
            #      print @testData[count]
            #      print ','
            update_coeffs_per_sample(count)
            count += 1
          end
          per_block_processing
          magnitude_filter
          calc_real_state
          calc_filtered_state
          decode_signal
          store_high_period
          store_filtered_state
          break if done
        end
        #        break if loop_count > 10000
        loop_count += 1
      end
      print_char
      puts
    end
  end
end
