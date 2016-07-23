# encoding: utf-8

module CWG

class BookDetails

  attr_reader :args

  HERE = File.dirname(__FILE__) + '/'
  GEM_BOOK_DIRECTORY     = HERE + '../../data/text/'
  GEM_BOOK_NAME          = 'book.txt'
  DEFAULT_BOOK_DIRECTORY = 'books'

  def initialize
    book_directory
    book_name
  end

  def is_default_book_dir?
    if File.exist? DEFAULT_BOOK_DIRECTORY
      if File.directory? DEFAULT_BOOK_DIRECTORY
        return true
      end
    end
    false
  end

  def book_name
    Params.book_name ||= GEM_BOOK_NAME
  end

  def book_directory
    book_dir = GEM_BOOK_DIRECTORY
    if is_default_book_dir?
      book_dir = DEFAULT_BOOK_DIRECTORY
    end
    Params.book_dir ||= book_dir
  end

  def book_location
    temp = File.expand_path(book_name, book_directory)
  end

  def arguments args
    @args = args
    @args[:output] = :letter unless @args[:output]
    if @args[:duration]
      @timeout = Time.now + @args[:duration] * 60.0
    end
  end

  def session_finished?
    sentences_complete? || book_timeout?
  end

  def sentences_complete?
    if @args.has_key?(:sentences) &&  @args[:sentences].is_a?(Fixnum)
      if @sentence_count_source
        @sentence_count_source = nil
      else
        @args[:sentences] -= 1
        @sentence_count_source = true
      end
      true if(@args[:sentences] < 0)
    end
  end

  def book_timeout?
    @timeout && (Time.now > @timeout)
  end
end
end
