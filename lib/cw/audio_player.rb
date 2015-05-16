class AudioPlayer

  def tone
    @tone ||= ToneGenerator.new
  end

  def play_command
    @play_command ||= 'afplay'
  end

  def play_filename_for_ebook2cw
    @play_filename ||= "#{Params.audio_dir}/#{Params.audio_filename}0000.mp3"
  end

  def convert_words_with_ebook2cw words
    words = words.gsub("\n","")
    cl = Cl.new.cl_echo(words)
    ! @dry_run ? `#{cl}` : cl
  end

  def convert_words words
    tone.generate words           unless Params.use_ebook2cw
    convert_words_with_ebook2cw words if Params.use_ebook2cw
  end

  def play_filename
    return play_filename_for_ebook2cw if Params.use_ebook2cw
    tone.play_filename
  end

  def play
    cmd = play_command + ' ' + play_filename
    @pid = ! @dry_run ? Process.spawn(cmd) : cmd
  end

  def stop
    begin
      Process.kill(:TERM, @pid)
      Process.wait(@pid)
    rescue
    end
  end

  def play_tone tone
    `#{play_command + ' ' + tone}`
  end

  def play_cmd_for_ps
    '[' << play_command[0] << ']' << play_command[1..-1]
  end

  def still_playing?
    ps = `ps -ewwo pid,args | grep #{play_cmd_for_ps}`
    return ps.include? "#{play_filename_for_ebook2cw}" if Params.use_ebook2cw
    return ps.include? tone.play_filename unless Params.use_ebook2cw
  end

  def startup_delay
    0.2
  end
end
