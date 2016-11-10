# encoding: utf-8

require 'wavefile'

module CWG

  class ToneGenerator

    MUTE = false

    include ToneHelpers
    include FileDetails

    class Code

      include FileDetails

      def initialize sample_rate, wpm
        @sample_rate = sample_rate
        @wpm = wpm
        @spb_short = @sample_rate * 1.2 / @wpm
        @spb_long = @sample_rate * 3.6 / @wpm
      end

      def filename element
        self.send "#{element}_path"
      end

      def spb element
        spb = element == :dash ?
                @spb_long    :
                @spb_short
        spb.to_i
      end
    end

    def initialize
      @sample_rate = 2400
      @max_amplitude = (Cfg.config["volume"].to_f > 1.0 ?
                          1.0 : Cfg.config["volume"].to_f)
      @wpm = Cfg.config["wpm"].to_f
      @frequency = Cfg.config["frequency"].to_i
      @effective_wpm = Cfg.config["effective_wpm"] ?
                         Cfg.config["effective_wpm"].to_f : @wpm
      @print = Print.new
    end

    def code
      @code ||= Code.new(@sample_rate, @wpm)
    end

    def generate wrds
      word_parts(wrds)
      compile_fundamentals
      write_word_parts
    end

    def play_filename
      @play_filename ||= File.join(audio_dir, audio_filename)
    end

    def cw_encoding
      @encoding ||= CwEncoding.new
    end

    def progress
      @progress ||= Progress.new('Compiling')
    end

    def filter_maybe(size, count)
      ramp = 0.05
      ramp_point =  @max_amplitude / ramp
      ampl = (count < ramp_point) ? (ramp * count) : @max_amplitude
      (count > (size - ramp_point)) ? (ramp * (size - count)) : ampl
    end

    def generate_tone(number_of_samples)
      audio_samples = [].fill(0.0, 0, number_of_samples)
      number_of_samples.times do |sample_number|
        amplitude = filter_maybe(number_of_samples, sample_number)
        #      amplitude = 1.0 # @max_amplitude
        #      amplitude = 0.01 if MUTE
        sine_radians = ((@frequency * TWO_PI) / @sample_rate) * sample_number
        audio_samples[sample_number] = amplitude * Math.sin(sine_radians)
      end
      audio_samples
    end

    def generate_buffer audio_samples, ele
      WaveFile::Buffer.new(audio_samples,
                           WaveFile::Format.new(:mono, :float, code.spb(ele)))
    end

    def write_element_audio_file ele, buffer
      WaveFile::Writer.new(code.filename(ele),
                           WaveFile::Format.new(:mono, :pcm_16, @sample_rate)) do |writer|
        writer.write(buffer)
      end
    end

    def elements
      [:dot, :dash, :space, :e_space]
    end

    def generate_samples ele
      return generate_space(code.spb(ele)) if space_sample? ele
      generate_tone(code.spb(ele))     unless space_sample? ele
    end

    def compile_fundamentals
      elements.each do |ele|
        audio_samples = generate_samples ele
        buffer = generate_buffer(audio_samples, ele)
        write_element_audio_file ele, buffer
      end
    end

    def ewpm?
      @effective_wpm != @wpm
    end

    def space_or_espace
      { name: (ewpm? ? :e_space : :space) }
    end

    def push_enc chr
      arry = []
      chr.each_with_index do |c,idx|
        arry << c
        arry << (last_element?(idx, chr) ? space_or_espace : { name: :space })
      end
      arry += char_space
    end

    def send_char(c)
      enc = c == ' ' ? [word_space] : cw_encoding.fetch(c).map { |e|
        { :name => e }
      }
      push_enc enc
    end

    def word_parts(str = nil)
      return @word_parts if @word_parts
      @word_parts = []
      str.split('').each { |part| @word_parts << part }
      @word_parts
    end

    def prepare_buffers
      @buffers = {}
      elements.each do |ele|
        @buffers[ele] = []
        WaveFile::Reader.new(code.filename(ele))
                        .each_buffer(code.spb(ele)) do |buffer|
          @buffers[ele] = buffer
        end
      end
    end

    def write_word_parts
      prepare_buffers
      write_audio_file
    end

    def char_space
      Array.new(2, word_space)
    end

    def word_space
      { name: (ewpm? ? :e_space : :space) }
    end

    def word_composite(word)
      send_char word.downcase
    end

    def format
      WaveFile::Format.new(:mono, :pcm_16, @sample_rate)
    end

    def write_buffer(writer, fta)
      writer.write(@buffers[fta[:name]])
    end

    def write_audio
      WaveFile::Writer.new(play_filename, format) do |writer|
        yield.map { |ch| ch.map { |fta| write_buffer(writer, fta) } }
      end
    end

    def write_audio_file
      write_audio do
        @word_parts.collect { |part| word_composite(part) }
      end
      reset
    end

    def reset
      @word_parts = @progress = nil
    end
  end
end
