# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name        = 'cw'
  spec.version     = '0.0.12'
  spec.date        = '2016-05-21'
  spec.authors     = ["Martyn Jago"]
  spec.email       = ["martyn.jago@btinternet.com"]
  spec.description = "A ruby library to help learn and practice morse code"
  spec.summary     = "CW tutor / exerciser"
  spec.homepage    = 'http://github.com/mjago/cw'
  spec.files       = `git ls-files`.split($/)
  spec.license     = 'MIT'
  spec.require_paths = ["lib", "audio", "data/text", "test"]

  spec.add_dependency('wavefile')
  spec.add_dependency('paint')
  spec.add_dependency('feedjira')
  spec.add_dependency('htmlentities')
  spec.add_dependency('sanitize')
  spec.add_dependency('ruby-progressbar')
  spec.add_dependency('rake')

  spec.add_development_dependency "minitest"
  spec.add_development_dependency "simplecov"
end
