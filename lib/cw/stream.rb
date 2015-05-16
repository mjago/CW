class Stream

  attr_accessor :active_region

  def initialize
    @active_region = 2
    empty
  end

  def empty
    @stream, @success, @first_element, @last_element = {},{}, 0, 0
  end

  def count
    @last_element - @first_element
  end

  def add word
    @stream[@last_element] = word.strip
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
    return_val = {}
    fail_unmarked_inactive_elements
    unless stream_empty?
      if(@first_element < inactive_region)
        pop
      elsif(@success[@first_element] == true || @success[@first_element] == false)
        pop
      end
    end
#    return_val == {} ? nil : return_val
  end

  def match_last_active_element(match)
    #    puts "matching last element"
    if ! stream_empty?
      first = @last_element - @active_region - 1
      first = 0 if(first < 0)
      found = false
      (@last_element - 1).downto(first) do |ele|
        #      puts "@stream[ele] = #{@stream[ele].inspect}\r"
        #      puts "match = #{match.inspect}\r"
        if found
          #        puts "found"
          @success[ele] = false unless @success[ele]
        elsif @stream[ele] == match && (@success[ele] == nil)
          @success[ele], found = true, true
          #        puts @stream.inspect
        else
          @success[first] = false
        end
      end
    end
  end
end

