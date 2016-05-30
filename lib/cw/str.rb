# encoding: utf-8

#class Str

class Str

  include TextHelpers

  def initialize
    @seperator = ', '
  end

  def to_s
    delim  = Params.delim_str
    [
      Params.name + "\n",
      delim,
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

  def beginning_str
    beginning = Params.begin
    beginning ? "Beginning:  #{stringify beginning}\n" : nil
  end

  def ending_str
    ending = Params.end
    ending ? "Ending:     #{stringify ending}\n" : nil
  end

end
