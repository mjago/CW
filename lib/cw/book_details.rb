# encoding: utf-8

module CW

  class BookDetails

    attr_reader :args

    include FileDetails

    BOOK_NAME = "book.txt"
    BOOK_DIR = TEXT
    USER_BOOK_DEFAULT_DIR = "books"

    def book_name
      @book_name ||=
        Cfg.config["book_name"] ?
          Cfg.config["book_name"] :
          BOOK_NAME
    end

    def is_user_book_default_dir?
      File.exists? USER_BOOK_DEFAULT_DIR
    end

    def book_dir
      @book_dir ||=
        Cfg.config["book_dir"] ?
          File.join(WORK_DIR, Cfg.config["book_dir"]) :
          is_user_book_default_dir? ?
            USER_BOOK_DEFAULT_DIR :
            BOOK_DIR
    end

    def book_location
      File.expand_path(book_name, book_dir)
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
      if @args.has_key?(:sentences) &&  @args[:sentences].is_a?(1.class)
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
