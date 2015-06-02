# encoding: utf-8

require 'ruby-progressbar'

class Progress

  def initialize(title)
    @title = title
  end

  def init size
    @progress =
      ProgressBar.
      create(total: size,
             title: 'Compiling',
             progress_mark: '.',
             length: 40,
             format: "%t: |%B| %p% ")
  end

  def increment
    @progress.increment
  end

end
