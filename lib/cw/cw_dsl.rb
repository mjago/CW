# encoding: utf-8

# class Cw_dsl provides CW's commands

class CwDsl

  HERE = File.dirname(__FILE__) + '/'
  COMMON_WORDS   = HERE + '../../data/text/common_words.txt'
  ABBREVIATIONS  = HERE + '../../data/text/abbreviations.txt'
  Q_CODES        = HERE + '../../data/text/q_codes.txt'

  def initialize
    @words, @cl, @str =
      Words.new, Cl.new, Str.new
    init_config
  end

  [:name,          :wpm,
   :effective_wpm, :word_spacing,
   :command_line,  :frequency,
   :author,        :title,
   :quality,       :audio_filename,
   :pause,         :noise,
   :shuffle,       :mark_words,
   :double_words,  :single_words,
   :audio_dir,     :def_word_count
  ].each do |method|
    define_method method do |arg = nil|
      arg ? Params.send("#{method}=", arg) : Params.send("#{method}")
    end
  end

  [[:pause, :pause, true],
   [:un_pause, :pause, nil],
   [:print_letters, :print_letters, true],
   [:mark_words, :print_letters, nil],
   [:noise, :noise, true],
   [:no_noise, :noise, nil],
   [:shuffle, :shuffle, true],
   [:no_shuffle, :shuffle, nil],
   [:double_words, :double_words, true],
   [:single_words, :double_words, nil],
   [:use_ebook2cw, :use_ebook2cw, true],
   [:use_ruby_tone, :use_ebook2cw, nil],
  ].each do |bool|
    define_method bool[0] do
      Params.send("#{bool[1]}=", bool[2])
      @words.shuffle if((bool[1] == :shuffle) && (bool[2]))
    end
  end

  def init_config
    Params.config do
      param :name, :wpm,
      :dictionary, :command_line, :audio_filename, :tone, :pause,
      :print_letters, :double_words,
      :word_filename, :author, :title, :quality, :frequency, :shuffle, :effective_wpm,
      :max, :min, :word_spacing, :noise, :begin, :end, :word_count, :including,
      :word_size, :size, :beginning_with, :ending_with, :mark_words, :audio_dir,
      :use_ebook2cw, :def_word_count
    end

    config_defaults
    config_files
  end

  def config_defaults
    Params.config {
      name           'unnamed'
      wpm            25
      frequency      500
      dictionary     COMMON_WORDS
      def_word_count 100
    }
  end

  def config_files
    Params.config {
      audio_dir      'audio'
      audio_filename 'audio_output'
      word_filename  'words.txt'
    }
  end

  def words
    @words.all
  end

  def words= words
    @words.add words
  end

#  def shuffle()
#    Params.shuffle = true
#    @words.shuffle if Params.shuffle && @words.exist?
#  end
#
#  def no_shuffle()
#    Params.shuffle = nil
#  end

  def word_size(size = nil)
    if size
      Params.size = size
      @words.word_size size
    end
    Params.size
  end

  def beginning_with(* letters)
    @words.beginning_with letters
    Params.begin = letters
  end

  def ending_with(* letters)
    @words.ending_with letters
    Params.end = letters
  end

  def word_count(wordcount)
    Params.word_count = wordcount
    @words.count wordcount
  end

  def including(* letters)
    Params.including = letters
    @words.including letters
  end

  def no_longer_than(max)
    Params.max = max
    @words.no_longer_than max
  end

  def no_shorter_than(min)
    Params.min = min
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

#  def add_noise
#    Params.noise = true
#  end

  def reload
    load_words(Params.dictionary)
  end

  def load_common_words
    load_words
  end

  def load_abbreviations
    load_words ABBREVIATIONS
  end

  def load_q_codes
    load_words Q_CODES
  end

  def load_words(filename = COMMON_WORDS)
    Params.dictionary = filename
    @words.load filename
  end

  def set_tone_type(type)
    case type
    when :squarewave, :sawtooth, :sinewave
      Params.tone = type
    end
  end

end
