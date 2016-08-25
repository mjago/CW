# encoding: utf-8

require 'wavefile'

module CWG

  class Read

    SAMPLE_FRAMES_PER_BUFFER = 2400
    TARGET_FREQ = 480
    N = 24
    SAMPLING_FREQ = 2400

    def initialize
      @code = []
      @cw_encoding = CwEncoding.new
      k = (0.5 + ((N * TARGET_FREQ) / SAMPLING_FREQ)).to_i
      omega = (2.0 * Math::PI * k) / N
      @sine = Math.sin(omega)
      @cosine = Math.cos(omega)
      @coeff = 2.0 * @cosine
      @q1 = 0.0
      @q2 = 0.0
      @magnitudelimit = 100
      @magnitudelimit_low = 100
      @wpm = 25
      @real_state = false
      @filtered_state = false
      @real_state_store = false
      @filtered_state_store = false
      @start_time = Time.now
      @noise_blanking_period = 6
      @start_time_high = 0
      @high_period = 0
      @high_period_store = 0
      @high_times_avg = 0
      @start_time_low = 0
      @low_period = 0
      @last_start_time = 0
      @millisecs = 0.0
      sample()
    end

    def millis
      @millisecs
    end

    def sample
      @testData = Array.new(N)
      count_N = 0
      WaveFile::Reader.new("audio/audio_output").each_buffer(SAMPLE_FRAMES_PER_BUFFER) do |buffer|
        loop do
          done = false
          count = 0
          N.times do
            length = buffer.samples.length
            done = true unless(length > 0)
            #@millisecs += 0.43405
            @millisecs += 1
            @testData[count] = (buffer.samples.shift) unless done # + 32768
            @testData[count] = 0 if done
            update_coeffs_per_sample(count)
            count += 1
          end
          per_block_processing
          magnitude_filter
          calc_real_state
          calc_filtered_state
          decode_signal
          break if done
        end
      end
      print_char
      puts
    end

    def update_coeffs_per_sample(count)
      q0 = @coeff * @q1 - @q2 + @testData[count].to_f
      @q2 = @q1
      @q1 = q0
    end

    def per_block_processing
      magnitude_squared = (@q1 * @q1) + (@q2 * @q2) - (@q1 * @q2 * @coeff)
      @magnitude = Math.sqrt(magnitude_squared);
      @q2 = 0;
      @q1 = 0;
    end

    def magnitude_filter
      if(@magnitude > @magnitudelimit_low)
        @magnitudelimit = (@magnitudelimit + ((@magnitude - @magnitudelimit) / 6))  # moving average filter
      elsif(@magnitudelimit < @magnitudelimit_low)
        @magnitudelimit = @magnitudelimit_low
      end
    end

    def calc_real_state
      @real_state =
        (@magnitude > (@magnitudelimit * 0.6)) ?
          true : false
    end

    def reset_last_start_time
      @last_start_time = millis()
    end

    def real_state_change?
      @real_state != @real_state_store
    end

    def filtered_state_change?
      @filtered_state != @filtered_state_store
    end

    def calc_filtered_state
      if real_state_change?
        reset_last_start_time
      end

      if((millis() - @last_start_time) > @noise_blanking_period)
        @filtered_state = @real_state
      end

      if filtered_state_change?
         if(@filtered_state == true)
           @start_time_high = millis()
           @low_period = (millis() - @start_time_low)
         end

         if (@filtered_state == false)
           @start_time_low = millis();
           @high_period = (millis() - @start_time_high);
           if((@high_period < (2 * @high_times_avg)) || (@high_times_avg == 0))
             @high_times_avg = (@high_period + @high_times_avg + @high_times_avg) / 3  # now we know avg dit time ( rolling 3 avg)
           end

           if(@high_period > (5 * @high_times_avg))
             @high_times_avg = @high_period + @high_times_avg;     # if speed decrease fast ..
           end
         end
      end
      store_real_state
    end

    def matched_timings?(period, avg, avg_x_high, avg_x_low)
      ((period < (avg * avg_x_high)) &&
       (period > (avg * avg_x_low)))
    end
    def decode_signal
      if(filtered_state_change?)
        if(@filtered_state == false) #  we did end a HIGH
          if matched_timings?(@high_period, @high_times_avg, 2.0, 0.6)
            #  0.6 filter out false dits
            @code << :dot
          end
          if matched_timings?(@high_period, @high_times_avg, 6.0, 2.0)
            @code << :dash
          end
        else # we did end a LOW
          if matched_timings?(@low_period, @high_times_avg, 5.0, 2.0) # letter space
            print_char
            @code.clear
          end
          if(@low_period >= (@high_times_avg * 5.0)) # word space
            print_char
            @code.clear
            print ' '
          end
        end
      end

      store_high_period
      store_filtered_state

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

    def print_char
      print matched_char
    end
  end
end
