# encoding: utf-8

class FileDetails
  HERE = File.dirname(__FILE__) + '/'
  TEXT = HERE + '../../data/text/'
  AUDIO = HERE + '../../audio/'

  def initialize
    @repeat_tone     = AUDIO + "rpt.mp3"
    @r_tone          = AUDIO + "r.mp3"
    @text_folder     = TEXT
    @progress_file   = 'progress.txt'
  end

end
