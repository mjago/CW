require 'coreaudio'

module CW

  class Coreaudio

    include ToneHelpers

    def initialize
      dev = CoreAudio.default_output_device
      @buf = dev.output_buffer(8192)
    end

    def ramp_filter(size, count)
      @max_amplitude = 1
      ramp = 0.03
      ramp_point =  @max_amplitude / ramp
      ampl = (count < ramp_point) ? (ramp * count) : @max_amplitude
      (count > (size - ramp_point)) ? (ramp * (size - count)) : ampl
    end

    def generate_tone(number_of_samples)
      @sample_rate = 44100
      @frequency = 1000
      @w = (@frequency * TWO_PI) / @sample_rate
      ary = []
      number_of_samples.round.times do |sample_number|
        amplitude = ramp_filter(number_of_samples, sample_number)
        sine_radians = @w * sample_number
        temp = (amplitude * Math.sin(sine_radians) * 0x7FFF).round
        ary << temp
      end
      @buf << ary
    end

    def generate_silence(number_of_samples)
      ary = []
      number_of_samples.round.times do |sample_number|
        ary << 0.0
      end
      @buf << ary
    end

    def start
      @buf.start
    end

    def stop
      @buf.stop
    end

#    def play_tone(wpm)
#      #      phase = Math::PI * 2.0 * 440.0 / dev.nominal_rate
#      th = Thread.start do
#        #        i = 0
#        #        loop do
#        #        wav = NArray.sint(1024)
##        p @buf
#        1.times do
#          generate_tone(1024 * wpm)
#          generate_silence(1024 * wpm)
#          generate_tone(1024 * wpm)
#          generate_silence(1024 * wpm)
#          generate_tone(1024 * wpm)
#          generate_silence(1024 * wpm)
#          generate_tone(1024 * wpm * 3)
#          generate_silence(1024 * wpm * 3)
#
#          generate_tone(1024 * wpm)
#          generate_silence(1024 * wpm)
#          generate_tone(1024 * wpm)
#          generate_silence(1024 * wpm)
#          generate_tone(1024 * wpm)
#          generate_silence(1024 * wpm)
#          generate_tone(1024 * wpm * 3)
#          generate_silence(1024 * wpm * 3)
#
#          generate_tone(1024 * wpm)
#          generate_silence(1024 * wpm)
#          generate_tone(1024 * wpm)
#          generate_silence(1024 * wpm)
#          generate_tone(1024 * wpm)
#          generate_silence(1024 * wpm)
#          generate_tone(1024 * wpm * 3)
#          generate_silence(1024 * wpm * 3)
#
#          generate_tone(1024 * wpm)
#          generate_silence(1024 * wpm)
#          generate_tone(1024 * wpm)
#          generate_silence(1024 * wpm)
#          generate_tone(1024 * wpm * 3)
#          generate_silence(1024 * wpm)
#          generate_tone(1024 * wpm)
#          generate_silence(1024 * wpm * 3)
#
#          generate_tone(1024 * wpm)
#          generate_silence(1024 * wpm)
#          generate_tone(1024 * wpm)
#          generate_silence(1024 * wpm)
#          generate_tone(1024 * wpm * 3)
#          generate_silence(1024 * wpm)
#          generate_tone(1024 * wpm)
#          generate_silence(1024 * wpm * 3)
#
#          generate_tone(1024 * wpm)
#          generate_silence(1024 * wpm)
#          generate_tone(1024 * wpm * 3)
#          generate_silence(1024 * wpm)
#          generate_tone(1024 * wpm)
#          generate_silence(1024 * wpm)
#          generate_tone(1024 * wpm)
#          generate_silence(1024 * wpm * 3)
#          generate_tone(1024 * wpm)
#          generate_silence(1024 * wpm)
#          generate_tone(1024 * wpm * 3)
#          generate_silence(1024 * wpm)
#          generate_tone(1024 * wpm)
#          generate_silence(1024 * wpm)
#          generate_tone(1024 * wpm)
#          generate_silence(1024 * wpm * 3)
#          generate_silence(1024 * wpm * 3)
#        end
#      end
#      @buf.start
#      th.join
#      @buf.stop
#      puts "#{@buf.dropped_frame} frame dropped."
#      th.kill.join
#
#      #     def listen words
#      #       play_tone
#      # #      @words = words
#      # #      p @words
#      # #      @cw_threads = Threads.new(self, thread_processes)
#      # #      @cw_threads.run
#      # #      reset_stdin
#      # #      print.newline
#      #     end
#      #
#      #   end
#
#    end
  end
end
