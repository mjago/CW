# encoding: utf-8

module CWG

  module FileDetails
    HERE  = File.dirname(__FILE__)
    ROOT  = File.expand_path File.join(HERE,'..','..')
    TEXT  = File.join(ROOT,'data','text')
    AUDIO = File.join(ROOT,'audio')

    ENGLISH_DICT     = File.join TEXT, "english.txt"
    ABBREVIATIONS    = File.join TEXT, "abbreviations.txt"
    Q_CODES          = File.join TEXT, "q_codes.txt"
    DOT_FILENAME     = File.join AUDIO, "dot.wav"
    DASH_FILENAME    = File.join AUDIO, "dash.wav"
    SPACE_FILENAME   = File.join AUDIO, "space.wav"
    E_SPACE_FILENAME = File.join AUDIO, "e_space.wav"
    CONFIG_FILENAME  = File.join ROOT, ".cw_config"

    def init_filenames
      @repeat_tone   = File.join(AUDIO, "rpt.mp3")
      @r_tone        = File.join(AUDIO, "r.mp3")
      @text_folder   = TEXT
      @progress_file = 'progress.txt'
    end

    def expand path
      File.expand_path path
    end
  end
end
