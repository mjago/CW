module CW
  class Callsign

    include FileDetails

    def callsigns
      if @callsigns.nil?
        @callsigns = load_callsigns
      end
      @callsigns
    end

    def load_callsigns
      File.open(CALLS_FILENAME, "r") do |calls|
        YAML::load(calls)
      end
    end


    def rand_val
      rand(100)
    end

    def select_part country = :uk, partial
      pc = rand_val
      weight = callsigns[country][partial][:weight]
      tot_wt = 0
      weight.each_with_index do |wt, idx|
        tot_wt += wt
        if pc < tot_wt
          part = callsigns[country][partial][:option][idx]
          return part unless(part.class == Range)
          return part.to_a.sample
        end
      end
    end

    def partial_name count
      "partial_#{count}".to_sym
    end

    def construct
      call = ''
      0.upto(4) do |count|
        call << select_part(partial_name(count))
      end
      call.strip
    end

    def * number
      calls = []
      number.times do
        calls << construct
      end
      calls
    end
  end
end
