module CWG

  class Callsign

    CALL_DATA = {
      :partial_0 => {
        :option => ['g','m','2e','gm','mm','gw', 'mw','ei','mi','gb'],
        :weight => [ 40, 20, 10,  4,   2,   4,    2,   5,   9  , 4  ]
      },
      :partial_1 => {
        :option => ['0','4','1','2','3','4','5','6','7','8','9','0'],
        :weight => [10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10]
      },
      :partial_2 => {
        :option => ['a'..'z'],
        :weight => [100]
      },
      :partial_3 => {
        :option => ['a'..'z'],
        :weight => [100]
      },
      :partial_4 => {
        :option => ['a'..'z', ''],
        :weight => [99,1]
      },
    }

    def rand_val
      rand(100)
    end


    def select_part partial
      pc = rand_val
      weight = CALL_DATA[partial][:weight]
      tot_wt = 0
      weight.each_with_index do |wt, idx|
        tot_wt += wt
        if pc < tot_wt
          part = CALL_DATA[partial][:option][idx]
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
