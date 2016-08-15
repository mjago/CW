# encoding: utf-8

# class Cw_dsl provides CW's commands

module CWG

  class CwDsl

    include CWG::Cfg

    HERE = File.dirname(__FILE__) + '/'
    TEXT = File.expand_path File.join(HERE,'..', '..','data','text')
    ABBREVIATIONS =  File.expand_path File.join TEXT, 'abbreviations.txt'
    Q_CODES =  File.expand_path File.join TEXT, 'q_codes.txt'
    [:wpm, :effective_wpm, :frequency, :audio_filename,:audio_dir,
     :book_name, :book_dir, :play_command, :run_default, :command_line,
     :author, :title, :quality, :ebook2cw_path, :list_colour, :list_colour,
     :success_colour, :fail_colour, :name, :tone, :volume, :print_words
    ].each do |method|
      define_method method do |arg = nil|
        arg ? Cfg.config.params[method.to_s] = arg :
          Cfg.config[method.to_s]
      end
    end

    def initialize
      @words, @cl, @str =
                   Words.new, Cl.new, Str.new
      Cfg.reset
      load_common_words# unless @words.exist?
    end

    def words
      @words.all
    end

    def words= words
      @words.add words
    end

    def word_size(size = nil)
      if size
        Cfg.config.params["size"] = size
        @words.word_size size
      end
      Cfg.config["size"]
    end

    def word_spacing(spacing)
      Cfg.config.params["word_spacing"] = spacing.to_i
    end

    # Test user against letters rather than words.
    #

    def test_letters
      Cfg.config.params["no_run"] = true
      test_letters = TestLetters.new
      test_letters.run @words
    end

    #todo
    #    def tx
    #      @words.add ["abc"]
    #      Cfg.config.params["no_run"] = true
    #      tx = Tx.new
    #      tx.listen @words
    #    end

    # Test user against complete words rather than letters.
    #

    def test_words
      Cfg.config.params["no_run"] = true
      tw = TestWords.new
      tw.run @words
    end

    # Repeat word repeats the current word if the word is entered incorrectly
    # (or not entered at all).

    def repeat_word
      Cfg.config.params["no_run"] = true
      repeat_word = RepeatWord.new
      repeat_word.run @words
    end

    # Reveal words only at end of test.
    # Useful for learning to copy `in the head'

    def reveal
      Cfg.config.params["no_run"] = true
      reveal = Reveal.new
      reveal.run @words
    end

    def sending_practice
      Params.sending_practice = true
      print_letters (:print_early)
    end

    # Play book using provided arguments.
    # @param [Hash] args the options to play book with.
    # @option args [Integer] :sentences Number of sentences to play
    # @option args [Integer] :duration  Number of minutes to play
    # @option args [Boolean] :letter Mark by letter if true else mark by word

    def read_book args = {}
      Cfg.config.params["no_run"] = true
      details = BookDetails.new
      details.arguments(args)
      book = Book.new details

      book.run @words
    end

    # Convert book to mp3.

    def convert_book args = {}
      details = BookDetails.new
      details.arguments(args)
      book = Book.new details
      Cfg.config.params["no_run"] = true
      book.convert
    end

    # Reads RSS feed (requires an internet connection). Feed can be one of:
    # - bbc:
    # - reuters:
    # - guardian:
    # - quotation:
    # @param [Symbol] source The source of the feed.
    # @param [Integer] article_count Number of articles to play.

    def read_rss(source, article_count = 3)
      rss, = Rss.new

      # don't go online if CW_ENV == test
      if(ENV["CW_ENV"] == "test")
        @words.assign ['test', 'rss', 'stub']
        return
      end
      rss.read_rss(source, article_count)
      loop do
        article = rss.next_article
        return unless article
        @words.assign article
        run
      end
    end

    def shuffle
      @words.shuffle unless(ENV["CW_ENV"] == "test")
    end

    def word_count(wordcount)
      Cfg.config.params["word_count"] = wordcount
      @words.count wordcount
    end

    def beginning_with(* letters)
      Cfg.config.params["begin"] = letters
      @words.beginning_with
    end

    def ending_with(* letters)
      Cfg.config.params["end"] = letters
      @words.ending_with
    end

    def including(* letters)
      Cfg.config.params["including"] = letters
      @words.including
    end

    def containing(* letters)
      Cfg.config.params["containing"] = letters
      @words.containing
    end

    def double_words
      @words.double_words
    end

    def repeat mult
      @words.repeat mult
    end

    def no_longer_than(max)
      @words.no_longer_than max
    end

    def no_shorter_than(min)
      @words.no_shorter_than min
    end

    def reverse
      @words.reverse
    end

    def letters_numbers
      @words.letters_numbers
    end

    def random_letters_numbers(options = {})
      options.merge!(letters_numbers: true)
      @words.random_letters_numbers options
    end

    def random_letters(options = {})
      @words.random_letters(options)
    end

    def random_numbers(options = {})
      @words.random_numbers(options)
    end

    def alphabet(options = {reverse: nil})
      @words.alphabet(options)
    end

    def numbers(options = {reverse: nil})
      @words.numbers(options)
    end

    def numbers_spoken()
      #todo
    end

    def load_common_words
      @words.load 1000
    end

    def load_most_common_words
      @words.load 1000
#      load_text MOST_COMMON_WORDS
    end

    def load_abbreviations
      load_text ABBREVIATIONS
    end

    def load_codes
      load_text Q_CODES
    end

    #todo refactor

    def alpha           ; 'a'.upto('z').collect{|ch| ch} ; end
    def vowels          ; ['a','e','i','o','u']          ; end
    def dot_letters     ; ['e','i','s','h']              ; end
    def dash_letters    ; ['t','m','o']                  ; end
    def load_vowels     ; @words.assign vowels           ; end
    def load_consonants ; @words.assign alpha - vowels   ; end
    def numbers         ; '0'.upto('9').collect{|ch| ch} ; end
    def load_numbers    ; @words.assign numbers          ; end
    def load_dots       ; load_letters(dot_letters)      ; end
    def load_dashes     ; load_letters(dash_letters)     ; end

    def cw_element_match arg
      encs = CWG::CwEncoding.new
      encs.match_elements arg
    end

    def letter_range args
      @words.assign alpha
      Cfg.config.params["including"] = args
      @words.including
    end

    def load_alphabet(* args)
      @words.assign alpha if args.empty?
      return if args.empty?
      if args[0].class == Range
        @words.assign letter_range(args)
        return
      end
      @words.assign cw_element_match(args)
    end

    def load_text(filename)
      Cfg.config.params["dictionary"] = filename
      @words.load_text filename
    end

    def load_words(args)
      @words.load args
    end

    # Return string containing name or comment of test.
    # @return [String] comment / name

    def to_s
      @str.to_s
    end

    def list
      Print.new.list self.to_s
      puts
    end

    def run_default
      Cfg.config["run_default"] || :test_letters
    end

    def print_letters
      Cfg.config.params["print_letters"] = true
    end

    def run
      return if Cfg.config["no_run"]
      self.send run_default
    end

    def no_run
      Cfg.config.params["no_run"] = true
    end

    def noise
      Cfg.config.params["noise"] = true
    end

    def no_noise
      Cfg.config.params["noise"] = nil
    end

    def use_ebook2cw
      Cfg.config.params["use_ebook2cw"] = true
    end

    def use_ruby_tone
      Cfg.config.params["use_ebook2cw"] = nil
    end

    alias_method :ewpm,                  :effective_wpm
    alias_method :comment,               :name
    alias_method :word_length,           :word_size
    alias_method :load_letters,          :load_alphabet
    alias_method :word_shuffle,          :shuffle
    alias_method :repeat_letter,         :repeat_word
    alias_method :having_size_of,        :word_size
    alias_method :number_of_words,       :word_count
    alias_method :words_including,       :including
    alias_method :words_ending_with,     :ending_with
    alias_method :random_alphanumeric,   :random_letters_numbers
    alias_method :words_beginning_with,  :beginning_with
    alias_method :words_no_longer_than,  :no_longer_than
    alias_method :words_no_shorter_than, :no_shorter_than

  end

end
