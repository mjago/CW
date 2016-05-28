# encoding: utf-8

class Stream

  attr_accessor :active_region

  def initialize
    @active_region = 6
    empty
  end

  def empty
    @stream, @success, @first_element, @last_element = {},{}, 0, 0
  end

  def count
    @last_element - @first_element
  end

  def add_word word
    @stream[@last_element] = word.strip
    @success[@last_element] = nil
    inc_last_element
  end

  def add_char char
    @stream[@last_element] = char
    @success[@last_element] = nil
    inc_last_element
  end

  def inc_last_element
    @last_element += 1
  end

  def inc_first_element
    @first_element += 1
  end

  def mark(element, type)
    @success[element] = type
  end

  def mark_success element
    mark element, true
  end

  def mark_fail element
    mark element, false
  end

  def stream_empty?
    @first_element == @last_element
  end

  def inactive_region
    stream_empty? ? nil : @last_element - @active_region - 1
  end

  def fail_unmarked_inactive_elements
    if(( ! stream_empty?) && (count > @active_region))
      @first_element.upto(inactive_region) do |count|
        @success[count] = false unless @success[count] == true
      end
    end
  end

  def first
    @stream[@first_element]
  end

  def pop
    unless stream_empty?
      ele = @first_element
      inc_first_element
      success = @success.delete(ele)
      success = success == nil ? false : success
      { :value => @stream.delete(ele),
        :success => success
      }
    else
      nil
    end
  end

#  def pop_marked
#    return_val = {}
#    fail_unmarked_inactive_elements
#    @first_element.upto(@last_element) do |ele|
#      unless stream_empty?
#        if(ele < inactive_region)
#          val = pop
#
#          return_val[ele] = {pop => @success[ele]}
#        elsif(@success[ele] == true || @success[ele] == false)
#          return_val[ele] = {pop => @success[ele]}
#        else
#          break
#        end
#      end
#    end
#    return_val == {} ? nil : return_val
#  end

  def pop_next_marked
    fail_unmarked_inactive_elements
    unless stream_empty?
      if(@first_element < inactive_region)
        pop
      elsif(@success[@first_element] == true || @success[@first_element] == false)
        pop
      end
    end
  end

  def element type
    return @last_element - 1 if type == :last
    first = @last_element - @active_region - 1
    first < 0 ? 0 : first
  end

  def match_first_active_element match
    if ! stream_empty?
      found = false
      first = element(:first)
      first.upto element(:last) do |ele|
        if found
          first.upto found - 1 do |failed|
            @success[failed] = false # unless @success[ele]
          end
          break
        elsif((@stream[ele] == match) && (! @success[ele]))
          @success[ele], found = true, ele
        else
          @success[first] = false
        end
      end
    end
  end

  def match_last_active_element(match)
    process_last_active_element(match) unless stream_empty?
  end

  def process_last_active_element(match)
    first = get_first
    last  = get_last
    check_last_element_success(match, first, last)
  end

  def check_last_element_success(match, first, last)
    found = false
    last.downto(first) do |ele|
      if found
        @success[element] = false unless @success[element]
      elsif((@stream[element] == match) && (! @success[element]))
        @success[element], found = true, true
      else
        @success[first] = false
      end
    end
  end

  def get_first
    first = @last_element - @active_region - 1
    first = 0 if(first < 0)
    first
  end

  def get_last
    @last_element - 1
  end
end
