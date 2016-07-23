# Module ToneHelpers provides helper methods for ToneGenerator

module CWG

  module ToneHelpers

    TWO_PI           = 2 * Math::PI
    HERE             = File.dirname(__FILE__) + '/../../'
    DOT_FILENAME     = HERE + "audio/dot.wav"
    DASH_FILENAME    = HERE + "audio/dash.wav"
    SPACE_FILENAME   = HERE + "audio/space.wav"
    E_SPACE_FILENAME = HERE + "audio/e_space.wav"

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
