# encoding: utf-8

module CWG

class Sentence

  attr_accessor :index #todo

  def text              ; @text ||= String.new   ; end
  def all               ; @sentences             ; end
  def next              ; @next = true           ; end
  def next?             ; @next                  ; end
#todo  def forward           ; @index += 1            ; end
  def forward           ; @index                 ; end
  def previous?         ; @previous              ; end
  def repeat?           ; @repeat                ; end
  def change?           ; next? || previous?     ; end
  def change_or_repeat? ; change? || repeat?     ; end
  def current           ; @sentences[@index]     ; end
  def next_sentence     ; @sentences[@index + 1] ; end

  def change
    forward if next?
    rewind if previous?
  end

  def rewind
    @index = @index <= 1 ? 0 : @index - 1
  end

  def create_progress_maybe progress_file
    unless File.exists? progress_file
      reset_progress progress_file
    end
  end

  def reset_progress progress_file
    @index = 0
    write_progress progress_file
  end

  def check_end_of_book progress_file
    if @index >= @sentences.size
      reset_progress progress_file
    end
  end

  def read_progress progress_file
    create_progress_maybe progress_file
    File.open(progress_file, 'r') {|f| @index = f.readline.to_i}
    unless(@index && @index.class == Fixnum)
      reset_progress progress_file
    end
    check_end_of_book progress_file
  end

  def write_progress progress_file
     File.open(progress_file, 'w') {|f| f.puts @index.to_s}
  end

  def read_book book
    File.open(book, 'r') { |f| text.replace f.readlines(' ').join}
  end

  def cw_chars chr
    chr.tr('^a-z0-9\,\=\!\/\?\.', '')
  end

  def exclude_non_cw_chars word
    cw_chars(word)
  end

  def find_all
    @sentences = []
    @text.gsub!(/\s+/, ' ').downcase!
    loop do
      sentence_end = @text.index('. ')
      unless sentence_end
        break
      end
      line = @text[0..sentence_end]
      line = line.split.collect{|word| exclude_non_cw_chars word}.join(' ')
      @sentences << line
      @text.replace @text[sentence_end + 2..-1]
    end
  end

  def check_sentence_navigation chr
    @next     = true if(chr == ']')
    @previous = true if(chr == '[')
    @repeat   = true if(chr == '-')
  end

  def reset_flags
    @next = @previous = @repeat = nil
  end

  def to_array
    array = @sentences[@index].split(' ')
    array.collect {|x| x + ' '}
  end

end

end
