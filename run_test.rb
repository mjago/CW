require('FileUtils');

GEM_VERSION = '0.2.0'
TEST_SCRIPT_DIR = './test_scripts'
HERE = File.dirname(__FILE__) + '/'

puts ARGV

@audio_src_file = "/usr/local/rvm/gems/ruby-2.3.0/gems/cw-0.2.0/audio/audio_output.wav"
@audio_dest_dir = "audio/"
@audio_dest_file = nil
@test_script_dir = 'test_scripts/'

if(ARGV[0].class == String)
  @audio_dest_file = HERE + @audio_dest_dir + ARGV[0] + '.wav'
  puts @audio_dest_file

  puts "running test_script..."
  system("ruby #{@test_script_dir + ARGV[0]}.rb")

  puts "converting mp3 file"
  @audio_dest_file = HERE + @audio_dest_dir + ARGV[0] + '.mp3'
  system("ffmpeg -i #{@audio_src_file} #{@audio_dest_file}")

  puts "converting ogg file"
  @audio_dest_file = HERE + @audio_dest_dir + ARGV[0] + '.ogg'
  system("ffmpeg -i #{@audio_src_file} #{@audio_dest_file}")

  puts "copying test_scripts to _includes"

  FileUtils.cp(Dir.glob('./test_scripts/*.rb'), '_includes')
else
  puts ("Error: run_test Usage: ruby run_test.rb test_script_name")
end
