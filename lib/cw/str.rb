# encoding: utf-8

module CWG

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
      Params.word_count_str,
      Params.word_size_str,
      beginning_str,
      ending_str,
      including_str,
      containing_str,
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

  def including_str
    including = Params.including
    including ? "Including:  #{stringify including}\n" : nil
  end

  def containing_str
    containing = Params.containing
    containing ? "Containing: #{stringify containing}\n" : nil
  end

end

end
