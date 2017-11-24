# encoding: utf-8

module CW

  #class Numbers provides the Number Testing functionality

  class Numbers

    def initialize(options = {})
      @options = options
    end

    def number_list
      '1234567890'
    end

    def reverse_numbers_maybe
      @numbers.reverse! if @options[:reverse]
    end

    def shuffle_numbers_maybe
      unless(ENV["CW_ENV"] == "test")
        @numbers = @numbers.split('').shuffle.join if @options[:shuffle]
      end
    end

    def generate
      @numbers = number_list
      shuffle_numbers_maybe
      reverse_numbers_maybe
      @numbers.split('').join(' ')
    end

  end

end
