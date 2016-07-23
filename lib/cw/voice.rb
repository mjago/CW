# encoding: utf-8

module CWG

  #class Speak speaks with a voice

  class Voice

    def initialize(options = {})
      @options = options
    end

    def say words, rate = 300, voice = 'bruce'
      system("say #{words} -ospoken.wave -r#{rate} -v#{voice}")
      system("afplay spoken.wave")
    end

  end

end
