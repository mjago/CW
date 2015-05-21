class BookDetails

  attr_reader :args

  def initialize
    @book_name      =  'tom_sawyer.txt'
    @book_directory =  'text/'
  end

  def book_location
    @book_directory + @book_name
  end

  def arguments args
    @args = args
    @args[:output] = :letter unless @args[:output]
    if @args[:duration]
      @timeout = Time.now + @args[:duration] * 60.0
    end
  end

  def session_finished? source
    sentences_complete?(source) || book_timeout?
  end

  def sentences_complete? source
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
