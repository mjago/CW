require('FileUtils');

GEM_VERSION = '0.2.0'
HERE = File.dirname(__FILE__) + '/'

puts ARGV

@audio_src_file = `bundle show cw`.strip + '/audio/audio_output'
puts "@audio_src_file = #{@audio_src_file}"
@audio_dest_dir = "audio/"
@audio_dest_file = nil
@cw_script_dir = 'cw_scripts/'

if(ARGV[0].class == String)
  @audio_dest_file = HERE + @audio_dest_dir + ARGV[0] + '.wav'
  puts "Writing audio file: " + @audio_dest_file

  puts "running cw_script..."
  system("cw #{@cw_script_dir + ARGV[0]}.rb")

  puts "converting mp3 file"
  @audio_dest_file = HERE + @audio_dest_dir + ARGV[0] + '.mp3'

  system("ffmpeg -i #{@audio_src_file} #{@audio_dest_file}")

#  puts "converting ogg file"
#  @audio_dest_file = HERE + @audio_dest_dir + ARGV[0] + '.ogg'
#  system("ffmpeg -i #{@audio_src_file} #{@audio_dest_file}")

  puts "copying cw_scripts to _includes"
  FileUtils.cp(Dir.glob('./cw_scripts/*.rb'), '_includes')
else
  puts ("Error: run_test Usage: ruby run_test.rb test_script_name")
end
