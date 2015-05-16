require 'wavefile'
require 'benchmark'

class ToneGenerator

  DOT_FILENAME     = "audio/dot.wav"
  DASH_FILENAME    = "audio/dash.wav"
  SPACE_FILENAME   = "audio/space.wav"
  E_SPACE_FILENAME = "audio/e_space.wav"
  TWO_PI           = 2 * Math::PI

  def initialize
    @max_amplitude = 0.5
    @wpm = Params.wpm
    @frequency = Params.frequency
    @effective_wpm = Params.effective_wpm ? Params.effective_wpm : @wpm
    @sample_rate      = 2400
  end

  def convert_words words
    words.to_array.collect{ |wrd| wrd.gsub("\n","")}
  end

  def generate words
    create_element_methods
    compile_fundamentals
    audio_stream = make_words words
    write_words audio_stream
  end

  def play_filename
#    'audio/output.wav'
    return 'audio/output.wav'    unless Params.audio_filename
    "audio/#{Params.audio_filename}" if Params.audio_filename
  end

  def play
    cmd = play_command + ' ' + play_filename
    @pid = ! @dry_run ? Process.spawn(cmd) : cmd
  end
  def data
    { :dot => {:filename => DOT_FILENAME,
        :spb => (@sample_rate * 1.2 / @wpm).to_i },
      :dash  => {:filename => DASH_FILENAME,
        :spb => (@sample_rate * 3.6 / @wpm).to_i },
      :space => {:filename   => SPACE_FILENAME   , :spb => (@sample_rate * 1.2 / @wpm).to_i },
      :e_space => {:filename => E_SPACE_FILENAME , :spb => (@sample_rate * 1.2 / @effective_wpm).to_i }}
  end

  def generate_space number_of_samples
    [].fill(0.0, 0, number_of_samples)
  end

  def filter_maybe(size, count)
    ramp = 0.05
    ramp_point =  @max_amplitude / ramp
    ampl = (count < ramp_point) ? (ramp * count) : @max_amplitude
    (count > (size - ramp_point)) ? (ramp * (size - count)) : ampl
  end

  def generate_tone(number_of_samples)
    position_in_period, position_in_period_delta =  0.0, @frequency / @sample_rate
    audio_samples = [].fill(0.0, 0, number_of_samples)
    number_of_samples.times do |sample_number|
      amplitude = filter_maybe(number_of_samples, sample_number)
      #      amplitude = 1.0 # @max_amplitude
      sine_radians = ((@frequency * TWO_PI) / @sample_rate) * sample_number
      audio_samples[sample_number] = amplitude * Math.sin(sine_radians)
    end
    audio_samples
  end

  def generate_buffer audio_samples, ele
    WaveFile::Buffer.new(audio_samples, WaveFile::Format.new(:mono, :float, data[ele][:spb]))
  end

  def write_audio_file ele, buffer
    WaveFile::Writer.new(data[ele][:filename], WaveFile::Format.new(:mono, :pcm_16, @sample_rate)) do |writer|
      writer.write(buffer)
    end
  end

  def elements
    [:dot, :dash, :space, :e_space]
  end

  def create_element_method ele
    define_singleton_method(ele) {data[ele]}
  end

  def create_element_methods
    elements.each do |ele|
      create_element_method ele
    end
  end

  def space_sample? ele
    ele == :space || ele == :e_space
  end

  def generate_samples ele
    return generate_space(data[ele][:spb]) if space_sample? ele
    generate_tone(data[ele][:spb])  unless    space_sample? ele
  end

  def compile_fundamentals
    elements.each do |ele|
      audio_samples = generate_samples ele
      buffer = generate_buffer(audio_samples, ele)
      write_audio_file ele, buffer
    end
  end

  def space_or_espace
    (@effective_wpm == @wpm) ? space : e_space
    end

  def last_element? idx, chr
    idx == chr.size - 1
  end

  def push_char chr
    arry = []
    chr.each_with_index do |c,idx|
      arry << c
      arry << ((last_element?(idx, chr)) ? (space_or_espace) : space)
    end
    arry += char_space
  end

  def send_char c
    name = case c
           when '.' then 'stop'
           when ',' then 'comma'
           when '!' then 'exclamation'
           when '=' then 'break'
           when '/' then 'slash'
           when '?' then 'question_mk'
           when ' ' then 'word_space'
           else
             '_' + c
           end
    push_char send(name)
  end

  def make_words str
    word = []
    str.split('').each do |c|
      word += send_char c.downcase
    end
    word
  end

  def write_words(word)
    WaveFile::Writer.new(play_filename, WaveFile::Format.new(:mono, :pcm_16, @sample_rate)) do |writer|
      word.each do |fta|
        WaveFile::Reader.new(fta[:filename]).each_buffer(fta[:spb]) do |buffer|
          writer.write(buffer)
        end
      end
    end
  end

  def _a          ; [dot,dash]                     ; end
  def _b          ; [dash, dot, dot, dot]          ; end
  def _c          ; [dash,dot,dash,dot]            ; end
  def _d          ; [dash, dot, dot]               ; end
  def _e          ; [dot]                          ; end
  def _f          ; [dot,dot,dash,dot]             ; end
  def _g          ; [dash,dash,dot]                ; end
  def _h          ; [dot,dot,dot,dot]              ; end
  def _i          ; [dot,dot]                      ; end
  def _j          ; [dot,dash,dash,dash]           ; end
  def _k          ; [dash,dot,dash]                ; end
  def _l          ; [dot,dash,dot,dot]             ; end
  def _m          ; [dash,dash]                    ; end
  def _n          ; [dash,dot]                     ; end
  def _o          ; [dash,dash,dash]               ; end
  def _p          ; [dot,dash,dash,dot]            ; end
  def _q          ; [dash,dash,dot,dash]           ; end
  def _r          ; [dot,dash,dot]                 ; end
  def _s          ; [dot,dot,dot]                  ; end
  def _t          ; [dash]                         ; end
  def _u          ; [dot,dot,dash]                 ; end
  def _v          ; [dot,dot,dot,dash]             ; end
  def _w          ; [dot,dash,dash]                ; end
  def _x          ; [dash,dot,dot,dash]            ; end
  def _y          ; [dash,dot,dash,dash]           ; end
  def _z          ; [dash,dash,dot,dot]            ; end
  def _1          ; [dot,dash,dash,dash,dash]      ; end
  def _2          ; [dot,dot,dash,dash,dash]       ; end
  def _3          ; [dot,dot,dot,dash,dash]        ; end
  def _4          ; [dot,dot,dot,dot,dash]         ; end
  def _5          ; [dot,dot,dot,dot,dot]          ; end
  def _6          ; [dash,dot,dot,dot,dot]         ; end
  def _7          ; [dash,dash,dot,dot,dot]        ; end
  def _8          ; [dash,dash,dash,dot,dot]       ; end
  def _9          ; [dash,dash,dash,dash,dot]      ; end
  def _0          ; [dash,dash,dash,dash,dash]     ; end
  def stop        ; [dot,dash,dot,dash,dot,dash]   ; end
  def comma       ;  [dash,dash,dot,dot,dash,dash] ; end
  def exclamation ; [dash,dash,dot,dot,dash]       ; end
  def break       ; [dash,dot,dot,dot,dash]        ; end
  def slash       ; [dash,dot,dot,dash,dot]        ; end
  def question_mk ; [dot,dot,dash,dash,dot,dot]    ; end

  def char_space
    @effective_wpm == @wpm ? [space,space] : [e_space,e_space]
  end

  def word_space
    @effective_wpm == @wpm ? [space] : [e_space]
  end

end

