# CW Gemfile

source "https://rubygems.org"

require 'rbconfig'

puts RbConfig::CONFIG['target_os']
if RbConfig::CONFIG['target_os'].include?('darwin')
  gem 'coreaudio', '~> 0.0.11'
end
gemspec
