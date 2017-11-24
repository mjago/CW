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

  spec.required_ruby_version = '>= 2.2.8'
  spec.add_runtime_dependency 'oga', '~> 2.11'
  spec.add_runtime_dependency 'httpclient', '~> 2.8.3'
  spec.add_runtime_dependency 'htmlentities', '~> 4.3.4'
  spec.add_runtime_dependency 'paint', '~> 2.0.1'
  spec.add_runtime_dependency 'rake', '~> 12.3.0'
  spec.add_runtime_dependency 'ruby-progressbar'
  spec.add_runtime_dependency 'wavefile', '~> 0.8.1'
  spec.add_runtime_dependency 'parseconfig', '~> 1.0.8'
  spec.add_runtime_dependency 'rubyserial', '~> 0.4.0'

  spec.add_dependency         'os', '~> 1.0.0'

  spec.add_development_dependency 'version', '~> 1.1.1'
  spec.add_development_dependency 'minitest',  '~> 5.10.3'
  spec.add_development_dependency 'simplecov', '~> 0.15.1'
  spec.add_development_dependency 'yard', '~> 0.9.11'
  spec.add_development_dependency 'sequel', '~> 5.2.0'
  spec.add_development_dependency 'sqlite3', '~> 1.3.13'
end
