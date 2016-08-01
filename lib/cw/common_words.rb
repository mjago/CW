module CWG

  class CommonWords

    CONFIG  = ".cw_config"
    HERE    = File.dirname(__FILE__) + '/'

    def initialize
      @words = []
      path = File.join(HERE,'..','..','data','text')
      @file = File.join path, "english.txt"
    end

    def all
      File.foreach(@file).collect do |line|
      line.chomp
      end
    end

    def low last
      results = []
      count = 0
      File.foreach(@file).collect do |line|
        if count <= last
          results << line.chomp
        end
        count += 1
        break if count > last
      end
      results
    end

    def mid first, last
      results = []
      count = 0
      File.foreach(@file).collect do |line|
        if (count >= first) && (count <= last)
          results << line.chomp
        end
        count += 1
        break if count > last
      end
      results
    end

    def parse_quantity(quantity = :default)
      if quantity == :default
        return [0, 999]
      elsif quantity.class == Fixnum
        [0, quantity - 1]
        (0...quantity).collect {|q| q}
      elsif quantity.class == Range
        ary = quantity.to_a
        return ary[0] - 1, ary[-1] -1
#        ary.pop
#        ary.unshift ary[0] - 1
#        ary
      end
    end

    def read(quantity = :default)
      if quantity == :all
        @words = all
      else
        qty = parse_quantity(quantity)
        if qty[0] == 0
          @words = low qty[-1]
        else
          @words = mid qty[0], qty[1]
        end
      end
      @words
    end

    def to_a
      @words
    end
  end
end
