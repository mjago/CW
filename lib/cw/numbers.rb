# encoding: utf-8

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
    @numbers = @numbers.split('').shuffle.join if @options[:shuffle]
  end

  def generate
    @numbers = number_list
    shuffle_numbers_maybe
    reverse_numbers_maybe
    @numbers.split('').join(' ')
  end
end
