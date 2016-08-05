require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rake/version_task'
require 'yard'

Rake::VersionTask.new

Rake::TestTask.new do |t|

  t.pattern = "test/test_*.rb"
#  t.pattern = "test/test_config.rb"
end

YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb']   # optional
  t.options = ['--any', '--extra', '--opts'] # optional
end

desc "Test cw_scripts and check timings"
task :test_scripts do
  system "bundle exec ruby run_script_tests.rb"
  puts "done"
end
