class ConfigFile

  CONFIG       = ".cw_config"
  CONFIGS      = ['book_dir', 'book_name', 'wpm']
  HERE         = File.dirname(__FILE__) + '/'

  attr_reader :config

  def config
    @config ||= Hash.new
  end

  def readlines f
    f.readlines
  end

  def write_config(cfg, line)
    config[cfg.to_sym] = line.gsub(cfg + ':', '').strip
  end

  def match_config?(line, cfg)
    if line
      tmp = line.strip()[0, cfg.length]
      return true if(tmp == cfg)
    end
    false
  end

  def extract_config line
    CONFIGS.each do |cfg|
      if match_config?(line, cfg + ':')
        write_config(cfg, line)
        return
      end
    end
  end

  def read_config
    File.open(CONFIG,'r') do |f|
      lines = readlines(f)
      lines.each do |line|
        extract_config line
      end
    end
#    puts "config: " + config.to_s
  end

  def read_config_maybe
    if File.exist?(CONFIG)
      puts 'Reading config:'
      read_config
      config
    end
  end
end
