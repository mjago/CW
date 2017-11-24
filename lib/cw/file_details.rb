# encoding: utf-8

module CW
  module FileDetails
    HERE          = File.dirname(__FILE__)
    WORK_DIR      = Dir.pwd
    ROOT          = File.expand_path File.join(HERE,'..','..')
    DATA          = File.join(ROOT,'data')
    AUDIO_DIR     = File.join(WORK_DIR,'audio')
    TEXT          = File.join(DATA,'text')
    CODE          = File.join(DATA,'code')
    CALLS         = File.join(DATA,'callsign')
    DOT_CW_DIR    = File.join WORK_DIR, ".cw"
    DOT_AUDIO_DIR = File.join DOT_CW_DIR, "audio"
    DICT_FILENAME      = "english.txt"
    CONFIG_FILENAME    = ".cw_config"
    DEF_AUDIO_FILENAME = "audio_output.wav"
    CODE_FILENAME      = File.join CODE, "code.yaml"
    CALLS_FILENAME     = File.join CALLS, "callsign.yaml"
    DOT_FILENAME       = "dot.wav"
    DASH_FILENAME      = "dash.wav"
    SPACE_FILENAME     = "space.wav"
    E_SPACE_FILENAME   = "e_space.wav"
    BOOKMARK_FILE      = "bookmark.txt"
    DICT_DIR           = TEXT
    ABBREVIATIONS      = File.join TEXT, "abbreviations.txt"
    Q_CODES            = File.join TEXT, "q_codes.txt"
    CONFIG_PATH        = File.join ROOT, CONFIG_FILENAME
    USER_CONFIG_PATH   = File.join WORK_DIR, CONFIG_FILENAME

    def init_filenames
      @repeat_tone     = File.join(AUDIO_DIR, "rpt.mp3")
      @r_tone          = File.join(AUDIO_DIR, "r.mp3")
    end

    def process_dot_cw
      Dir.mkdir(DOT_CW_DIR) unless File.exists? DOT_CW_DIR
      DOT_CW_DIR
    end

    def dot_cw_dir
      @dot_cw_dir ||= process_dot_cw
    end

    def process_dot_audio
      Dir.mkdir(DOT_AUDIO_DIR) unless(dot_cw_dir && File.exists?(DOT_AUDIO_DIR))
      DOT_AUDIO_DIR
    end

    def dot_audio_dir
      @dot_audio_dir ||= process_dot_audio
    end

    def dot_path
      File.join dot_audio_dir, DOT_FILENAME
    end

    def dash_path
      File.join dot_audio_dir, DASH_FILENAME
    end

    def space_path
      File.join dot_audio_dir, SPACE_FILENAME
    end

    def e_space_path
      File.join dot_audio_dir, E_SPACE_FILENAME
    end

    def default_audio_dir
      Dir.mkdir(AUDIO_DIR) unless File.exists? AUDIO_DIR
      AUDIO_DIR
    end

    def process_audio_dir
      Cfg.config['audio_dir'] ? user_audio_dir : default_audio_dir
    end

    def user_audio_dir
      @user_audio_dir ||=
        unless File.exists? Cfg.config['audio_dir']
          Dir.mkdir Cfg.config['audio_dir']
        end
      Cfg.config['audio_dir']
    end

    def audio_dir
      @audio_dir ||= process_audio_dir
    end

    def audio_filename
      @audio_filename ||=
        Cfg.config["audio_filename"] ?
          Cfg.config["audio_filename"] :
          DEF_AUDIO_FILENAME
    end

    def progress_file
      File.join(dot_cw_dir, BOOKMARK_FILE)
    end

  end
end
