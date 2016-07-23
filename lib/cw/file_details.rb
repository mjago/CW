# encoding: utf-8

module CWG

module FileDetails
  HERE = File.dirname(__FILE__) + '/'
  TEXT = HERE + '../../data/text/'
  AUDIO = HERE + '../../audio/'

  def init_filenames
    @repeat_tone     = AUDIO + "rpt.mp3"
    @r_tone          = AUDIO + "r.mp3"
    @text_folder     = TEXT
    @progress_file   = 'progress.txt'
  end

end

end
