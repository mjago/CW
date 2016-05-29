# encoding: utf-8

#class Str

class Str

  include TextHelpers

  def initialize
    @seperator = ', '
  end

  def to_s
    delim  = delim_std_str
    [
      "#{Params.name}\n",
      "#{delim}",
      Params.wpm_str,
      Params.shuffle_str,
      Params.word_count_str,
      Params.word_size_str,
      beginning_str,
      ending_str,
      delim
    ].collect{ |prm| prm.to_s }.join
  end

  def stringify ary
    ary.join(@seperator)
  end

  def delim_std_str
    tempsize = Params.name.size
    delim_str tempsize
  end

#FIXME
#  def shuffle_str
#    shuffle =  Params.shuffle
#    shuffle ? "Shuffle:    #{shuffle ? 'yes' : 'no'}\n" : nil
#  end
#
#  def word_count_str
#    wc = Params.word_count
#    wc ? "Word count: #{wc}\n" : nil
#  end
#  def wpm_str
#    "WPM:        #{Params.wpm}\n"
#  end
#  def word_size_str
#    size = Params.size
#    size ? "Word size:  #{size}\n" : nil
#  end



  def beginning_str
    beginning = Params.begin
    beginning ? "Beginning:  #{stringify beginning}\n" : nil
  end

  def ending_str
    ending = Params.end
    ending ? "Ending:     #{stringify ending}\n" : nil
  end

end
