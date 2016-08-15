# Module ToneHelpers provides helper methods for ToneGenerator

module CWG

  module ToneHelpers

    TWO_PI           = 2 * Math::PI

    def convert_words wrds
      wrds.to_array.collect{ |wrd| wrd.delete("\n")}
    end

    def generate_space number_of_samples
      [].fill(0.0, 0, number_of_samples)
    end

    def space_sample? ele
      ele == :space || ele == :e_space
    end

    def last_element? idx, chr
      idx == chr.size - 1
    end
  end
end
