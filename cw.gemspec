# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name        = 'cw'
  spec.version     = File.read('VERSION')
  spec.date        = '2016-05-21'
  spec.authors     = ["Martyn Jago"]
  spec.email       = ["martyn.jago@btinternet.com"]
  spec.description = "A ruby library to help learn and practice morse code"
  spec.summary     = "CW tutor / exerciser"
  spec.homepage    = 'http://martynjago.co.uk/CW/'
  spec.files       = `git ls-files`.split($/)
  spec.executables = "cw"
  spec.bindir      = 'bin'
  spec.license     = 'MIT'

  spec.require_paths = ["lib", "audio", "data/text", "test"]

  spec.required_ruby_version = '>= 2.0.0'
  spec.add_runtime_dependency 'feedjira', '>= 2.0.0'
  spec.add_runtime_dependency 'htmlentities', '>= 4.3.4'
  spec.add_runtime_dependency 'paint', '>= 1.0.1'
  spec.add_runtime_dependency 'rake', '>= 11.2.2'
  spec.add_runtime_dependency 'ruby-progressbar', '>= 1.8.1'
  spec.add_runtime_dependency 'sanitize', '~> 4.2.0'
  spec.add_runtime_dependency 'wavefile', '>= 0.7.0'
  spec.add_runtime_dependency 'parseconfig', '~> 1.0.8'
  spec.add_dependency         'os', '~> 0.9.6'

  spec.add_development_dependency 'version', '>= 1.0.0'
  spec.add_development_dependency 'minitest',  '>= 5.8.4'
  spec.add_development_dependency 'simplecov', '>= 0.12.0'
  spec.add_development_dependency 'yard', '~> 0.9.5'
  spec.add_development_dependency 'sequel'
  spec.add_development_dependency 'sqlite3'
end
