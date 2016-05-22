# encoding: utf-8

class FileDetails
  HERE = File.dirname(__FILE__) + '/'
  TEXT = HERE + '../../data/text/'

  def initialize
    @repeat_tone     = "../tom2/rpt.mp3"
    @r_tone          = "../tom2/r.mp3"
    @sentence_folder = "../tom2/"
    @text_folder     = TEXT
    @progress_file   = 'progress.txt'
  end

end
