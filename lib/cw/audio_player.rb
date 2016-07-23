# encoding: utf-8

require 'timeout'

module CWG

class AudioPlayer

  AFPLAY = '/usr/bin/afplay'

  def tone
    @tone ||= ToneGenerator.new
  end

  def play_command
    @play_command ||= AFPLAY
  end

  def play_filename_for_ebook2cw
    @play_filename ||= File.expand_path(Params.audio_filename, audio_dir)
  end

  def audio_dir
    Params.audio_dir ||= './audio'
  end

  def temp_filename_for_ebook2cw
    File.expand_path("tempxxxx.txt", audio_dir)
  end

  def convert_book words
    words = words.delete("\n")
    File.open(temp_filename_for_ebook2cw, 'w') do |file|
      file.print words
    end
    cl = Cl.new.cl_full(temp_filename_for_ebook2cw)
    ! @dry_run ? `#{cl}` : cl
    File.delete(temp_filename_for_ebook2cw)
    File.rename(play_filename_for_ebook2cw + '0000.mp3', play_filename_for_ebook2cw)
  end

#FIXME dry_run
  def convert_words_with_ebook2cw words
    words = words.delete("\n")
    cl = Cl.new.cl_echo(words)
    ! @dry_run ? `#{cl}` : cl
    File.rename(play_filename + '0000.mp3', play_filename)
  end

  def convert_words words
    tone.generate words           unless Params.use_ebook2cw
    convert_words_with_ebook2cw words if Params.use_ebook2cw
  end

  def play_filename
    return play_filename_for_ebook2cw if Params.use_ebook2cw
    tone.play_filename
  end

#FIXME dry_run
  def play
    cmd = play_command + ' ' + play_filename
    @pid = ! @dry_run ? Process.spawn(cmd) : cmd
    Process.waitpid(@pid)
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
end
