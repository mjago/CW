require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rake/version_task'

Rake::VersionTask.new

Rake::TestTask.new do |t|

  t.pattern = "test/test_*.rb"
#  t.pattern = "test/test_config.rb"
end

YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb']   # optional
  t.options = ['--any', '--extra', '--opts'] # optional
end
