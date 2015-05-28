# encoding: utf-8

#class Cl performs command-line processing

class Cl

  def initialize
    @tone = {
      sinewave: 0,
      sawtooth: 1,
      squarewave: 2
    }
  end

  def cl_wpm
    wpm = Params.wpm
    wpm ? "-w #{wpm} " : ''
  end

  def cl_effective_wpm
    ewpm = Params.effective_wpm
    ewpm ? "-e #{ewpm} " : ''
  end

  def cl_word_spacing
    ws = Params.word_spacing
    ws ? "-W #{ws} " : ''
  end

  def cl_frequency
    freq = Params.frequency
    freq ? "-f #{freq} " : ''
  end

  def cl_squarewave
    sqr = Params.tone == :squarewave
    sqr ? "-T #{@tone[:squarewave]} " : ''
  end

  def cl_sawtooth
    st = Params.tone == :sawtooth
    st ? "-T #{@tone[:sawtooth]} " : ''
  end

  def cl_sinewave
    sin = Params.tone == :sinewave
    sin ? "-T #{@tone[:sinewave]} " : ''
  end

  def cl_author
    author = Params.author
    author ? "-a \"#{author}\" " : ''
  end

  def cl_title
    title = Params.title
    title ? "-t \"#{title}\" " : ''
  end

  def cl_noise
    noise = Params.noise
    noise ? "-N 5 -B 1000 " : ''
  end

  def cl_audio_filename
    "-o \"#{Params.audio_dir}/#{Params.audio_filename}\" "
  end

  def coarse_quality(quality)
    {
      :high =>   "-q 1 ",
      :medium => "-q 5 ",
      :low =>    "-q 9 "
    }[quality]
  end

  def cl_quality
    quality = Params.quality
    if quality && quality.class == Fixnum
      "-q #{quality} "
    else
      coarse_quality quality
    end
  end

  def cl_command_line
    cl = Params.command_line
    cl ? "#{cl}" : ''
  end

  def build_command_line
    [ cl_wpm,
      cl_effective_wpm,
      cl_word_spacing,
      cl_frequency,
      cl_squarewave,
      cl_sawtooth,
      cl_sinewave,
      cl_author,
      cl_title,
      cl_noise,
      cl_audio_filename,
      cl_quality,
      cl_command_line
    ].collect{|param| param}.join
  end

  def cl_echo words
    "echo #{words} | ebook2cw #{build_command_line}"
  end

end
