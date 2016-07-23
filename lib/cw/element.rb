module CWG

module Element

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
    last.downto(first) do |element|
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

  def count
    @last_element - @first_element
  end

  def inc_last_element
    @last_element += 1
  end

  def inc_first_element
    @first_element += 1
  end

end

end
