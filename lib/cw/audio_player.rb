# encoding: utf-8

require 'timeout'
require 'os'

module CWG

  class AudioPlayer

    include FileDetails
    include CWG::OStest

    def tone
      @tone ||= ToneGenerator.new
    end

    def os_play_command
      if is_mac?
        'afplay'
      elsif is_posix?
        'ossplay'
      else
        puts 'Error - play_command required in .cw_config'
        exit 1
      end
    end

    def play_command
      if Cfg.config["play_command"].nil?
        Cfg.config.params["play_command"] =
          os_play_command
      end
      Cfg.config["play_command"]
    end

    def play_filename_for_ebook2cw
      @play_filename ||= File.join(audio_dir, audio_filename)
      puts "@play_filename = #{@play_filename}"
      @play_filename
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

    def convert_words_with_ebook2cw words
      words = words.delete("\n")
      cl = Cl.new.cl_echo(words)
      ! @dry_run ? `#{cl}` : cl
      File.rename(play_filename + '0000.mp3', play_filename)
    end

    def convert_words words
      tone.generate words if Cfg.config["use_ebook2cw"].nil?
      convert_words_with_ebook2cw words if Cfg.config["use_ebook2cw"]
    end

    def play_filename
      return play_filename_for_ebook2cw if Cfg.config["use_ebook2cw"]
      tone.play_filename
    end

    def play
      cmd = play_command + ' ' + play_filename
      @pid = ! @dry_run ? Process.spawn(cmd) : cmd
      begin
        Process.waitpid(@pid) if @pid.is_a?(1.class)
      rescue Errno::ECHILD
      end
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
      cl = "ps -eo  pid,args | grep #{play_cmd_for_ps}"
      ps = `#{cl}`
      return ps.include?("#{play_filename_for_ebook2cw}") if Cfg.config["use_ebook2cw"]
      return ps.include?(tone.play_filename) unless Cfg.config["use_ebook2cw"]
    end
  end
end
