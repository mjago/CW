# encoding: utf-8

#require 'wavefile'
require 'coreaudio'

module CWG

  SAMPLE_RATE = 44100
  MAGNITUDE_CUTOFF = 100 #  200000
  N = 441
  START = 0
  VALUE = 1
  BLANKING = 2
  FILTERED = 3
  PREV = 4
  PERIOD = 1
  AVG = 2

  class Read

    def n ; N ; end
    def k ; (0.5 + ((n * @tone / @sample_rate))).to_i ; end
    def w ; ((2 * Math::PI) / n) * k ; end
    def cosine ; Math.cos(w) ; end
    def coeff ; 2 * cosine ; end
    def n_delay_ms ;  n * 10000/SAMPLE_RATE; end
    def print ; @print ; end

    def initialize(filename)
      @tone = 882
      @mag_max = 0
      @mag_min = 999999999
      @sample_rate = SAMPLE_RATE
      @n_val = n
      @coeff = coeff
      @n_delay_ms = n_delay_ms
      @filename = filename
      @code = []
      @q1 = 0
      @q2 = 0
      @magnitude_set_point = 10000
      @magnitude_set_point_low = @magnitude_set_point
      @wpm = 15
      @noise_blanking_ms = 4
      @last_start_time = 0
      @state = Array.new(5)
      @high = Array.new(3)
      @low = Array.new(2)
      @queue = Queue.new
      @cw_encoding = CwEncoding.new
      @print = Print.new
      @state[START] = 0
      @state[VALUE] = :low
      @state[BLANKING] = false
      @state[FILTERED] = false
      @state[PREV] = false
      @high[START] = 0
      @high[PERIOD] = 0
      @high[AVG] = 0
      @low[START] = 0
      @low[PERIOD] = 0
      @millisecs = 0
      @last = 0
      @need_space = false
      puts "@n_val  #{@n_val}"
      puts "@coeff  #{@coeff}"
      puts "@n_delay_ms #{@n_delay_ms}"
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
      dly = @n_delay_ms
      #      startup = 0
      open_sound_device
      nval = @n_val
      nval8 = nval * 8
      buf = @buf_in
      bufs = nil
      thr = Thread.fork do
        loop do
          @queue.push buf.read(nval8)
        end
      end
      loop do
        loop do
          bufs = @queue.pop
          break if @queue.empty?
        end
        count = 0
        8.times do
          nval.times do
            calc_coeff(bufs[count] + bufs[count + 1])
            count += 2
          end
          @millisecs += dly
          per_block_processing
          calc_real_state
          calc_filtered_state
          decode_signal
        end
      end
      @buf_in.stop
      $stdout.puts "done."
    end

    def dbg_print message
      if @millisecs > @last
        @last = @millisecs + 1000
        puts
        puts "  " + message
        @mag_min = 999999999
        @mag_max = 0
      end
    end

    def per_block_processing
      @magnitude = (@q1 * @q1) + (@q2 * @q2) - @q1 * @q2 * @coeff
      @magnitude = @magnitude.to_i / 1000000
      @magnitude = 0 if @magnitude < MAGNITUDE_CUTOFF
      #      if @magnitude >= 1000000000000.0
      #        @magnitude = Math.sqrt(magnitude_squared).to_i
      #      else
      #        @magnitude = 0
      #      end
      @q1, @q2 = 0, 0;
      #      p @magnitude
    end

    def magnitude_filter
      if(@magnitude > @magnitude_set_point_low)
        @magnitude_set_point = (@magnitude_set_point + ((@magnitude - @magnitude_set_point) / 6))  # moving average filter
      else
        @magnitude_set_point = @magnitude_set_point_low
      end
      #      dbg_print "@magnitude: #{@magnitude.to_s}\n  @magnitude_set_point: #{@magnitude_set_point.to_s}\n  @magnitude_set_point_low = #{@magnitude_set_point_low}"

      @mag_max = @magnitude if @magnitude > @mag_max
      @mag_min = @magnitude if @magnitude < @mag_min

      #      dbg_print "@magnitude: #{@magnitude.to_s}\n" +
      #                "  @mag_max: #{@mag_max.to_s}\n" +
      #                "  @mag_min: #{@mag_min.to_s}\n"
    end

    def calc_real_state
      @state[VALUE] =
        (@magnitude > (@magnitude_set_point * 0.6)) ?
          :high : :low
    end

    def calc_filtered_state
      if real_state_change?
        reset_noise_blanker
      end

      store_real_state

      if @state[BLANKING]
        if noise_blanked
          @state[FILTERED] = true
          if(@state[VALUE] == :high)
            @high[START] = @millisecs
            @high_mag = @magnitude
            #          dbg_print "high: #{@high_mag}\n  low: #{@low_mag}\n  set point: #{@magnitude_set_point}"
            @low[PERIOD] = (@millisecs - @low[START])
          else
            @low[START] = @millisecs;
            @low_mag = @magnitude
           @high[PERIOD] = (@millisecs -  @high[START]);
            if((@high[PERIOD] < (2 * @high[AVG])) || (@high[AVG] == 0))
              @high[AVG] = ((@high[PERIOD] + @high[AVG] + @high[AVG]) / 3)  # now we know avg dit time ( rolling 3 avg)
            elsif(@high[PERIOD] > (5 * @high[AVG]))
              @high[AVG] = @high[PERIOD] + @high[AVG];     # if speed decrease fast ..
            end
          end
        end
      end
    end

    def decode_signal
      if(@state[FILTERED])
        @state[FILTERED] = false
        @need_space = true
        if(@state[VALUE] == :low) #  we did end a HIGH
          if high_avg_compare?(@high[PERIOD], 0.6, 2.0)
            #  0.6 filter out false dits
            @code << :dot
#            $stdout.print '.'
          end
          if high_avg_compare?(@high[PERIOD], 2.0, 6.0)
            @code << :dash
#            $stdout.print '_'
            if @millisecs % 10 == 0
              @wpm = (@wpm + (1200 / ((@high[PERIOD]) / 3))) / 2;  # the most precise we can do ;o)
              # dbg_print "high #{@high[PERIOD]}"
            end
            # dbg_print @wpm
          end
        else # we did end a LOW
          @need_space = false
          if high_avg_compare?(@low[PERIOD], 2.0, 4.8) # letter space
            print_char
          elsif(high_avg_compare?(@low[PERIOD], 4.8, 6.0)) # word space
            print_char
            $stdout.print ' '
          end
        end
      end
#      dbg_print "millisecs #{@millisecs}"
      if @need_space
        #        puts 'here'
        if high_avg_compare?(@millisecs - @low[START], 6.0, 10)
          @need_space = false
          if @state[BLANKING] = false
          end
          print_char
          $stdout.print ' '
        end
      end
    end

    def high_avg_compare?(period, avg_x_low, avg_x_high)
      (period <= (@high[AVG] * avg_x_high).to_i) &&
        (period >= (@high[AVG] * avg_x_low).to_i)
    end

    def noise_blanked
      if((@millisecs - @state[START]) > @noise_blanking_ms)
        @state[BLANKING] = false
        return true
      end
    end

    def print_space
      @code = [:space]
      print_char
    end

    def calc_coeff(data)
      q0 = @coeff * @q1 - @q2 + data
      @q2, @q1 = @q1, q0
    end

    def reset_noise_blanker
      @state[BLANKING] = true
      @state[START] = @millisecs
    end

    def real_state_change?
      #      if @real_state != @real_state_prev
      #        $stdout.print 'hi' if @real_state == true
      #        $stdout.print 'low' if @real_state == false
      #      end
      @state[VALUE] != @state[PREV]
    end

    def store_real_state
      @state[PREV] = @state[VALUE]
    end

    def matched_char
      @cw_encoding.fetch_char @code
    end

    def print_char
      char = @cw_encoding.fetch_char @code
      #      if char == ' '
      #        puts "\n  high: #{@high_mag}\n"
      #      end

      if false # char == '*'
        #        @wpm -= 5
        @state[VALUE] = false
        @state[FILTERED] = false
        @state[PREV] = false
        #        @awaiting_space = false
        @low[PERIOD] = 0

       @high[PERIOD] = 0
        @high[PREV] = 0
        @high[AVG] = 0
        @low[START] = 0
        @millisecs = 0
        @last = 0
      end
      print.optimum char
      @code = []
    end
  end
end
