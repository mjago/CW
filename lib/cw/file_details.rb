# encoding: utf-8

module CWG

  module FileDetails
    HERE     = File.dirname(__FILE__)
    ROOT     = File.expand_path File.join(HERE,'..','..')
    DATA     = File.join(ROOT,'data')
    AUDIO    = File.join(ROOT,'audio')
    TEXT     = File.join(DATA,'text')
    CODE     = File.join(DATA,'code')
    CALLS    = File.join(DATA,'callsign')
    WORK_DIR = Dir.pwd

    ENGLISH_DICT     = File.join TEXT, "english.txt"
    ABBREVIATIONS    = File.join TEXT, "abbreviations.txt"
    Q_CODES          = File.join TEXT, "q_codes.txt"
    DOT_FILENAME     = File.join AUDIO, "dot.wav"
    DASH_FILENAME    = File.join AUDIO, "dash.wav"
    SPACE_FILENAME   = File.join AUDIO, "space.wav"
    E_SPACE_FILENAME = File.join AUDIO, "e_space.wav"
    CONFIG_FILENAME  = ".cw_config"
    CONFIG_PATH      = File.join ROOT, CONFIG_FILENAME
    USER_CONFIG_PATH = File.join WORK_DIR, CONFIG_FILENAME
    CODE_FILENAME    = File.join CODE, "code.yaml"
    CALLS_FILENAME   = File.join CALLS, "callsign.yaml"

    def init_filenames
      @repeat_tone   = File.join(AUDIO, "rpt.mp3")
      @r_tone        = File.join(AUDIO, "r.mp3")
      @text_folder   = TEXT
      @progress_file = 'progress.txt'
    end
  end
end
