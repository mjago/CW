
#class Str

class Str

  def initialize
    @seperator = ', '
  end

  def to_s
    delim  = delim_std_str
    ["\n#{Params.name}\r",
     "\n#{delim}",
     "#{wpm_str}\n",
     shuffle_str,
     word_count_str,
     word_size_str,
     beginning_str,
     ending_str,
     delim].
      collect{ |prm| prm.to_s }.join
  end

  def stringify ary
    ary.join(@seperator)
  end

  def delim_str size
    "#{'=' * size}\n\r"
  end

  def delim_std_str
    tempsize = Params.name.size
    delim_str tempsize
  end

  def shuffle_str
    shuffle =  Params.shuffle
    shuffle ? "Shuffle:    #{shuffle ? 'yes' : 'no'}\n\r" : nil
  end

  def word_count_str
    wc = Params.word_count
    wc ? "Word count: #{wc}\n\r" : nil
  end

  def word_size_str
    size = Params.size
    size ? "Word size:  #{size}\n\r" : nil
  end

  def beginning_str
    beginning = Params.begin
    beginning ? "Beginning:  #{stringify beginning}\n\r" : nil
  end

  def ending_str
    ending = Params.end
    ending ? "Ending:     #{stringify ending}\n\r" : nil
  end

  def wpm_str
    "WPM:        #{Params.wpm}\n\r"
  end

end
