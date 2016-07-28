["audio_dir",
"audio_filename",
"author",
"book_dir",
"command_line",
"double_words",
"effective_wpm",
"ewpm",
"frequency",
"name",
"no_noise",
"noise",
"pause",
"print_letters",
"quality",
"shuffle",
"title",
"un_pause",
"use_ebook2cw",
"use_ruby_tone",
"word_spacing",
"wpm"].each do |name|
  File.open("cw_scripts/#{name}.rb", 'w') do |file|

    file.puts "require \"cw\""
    file.puts ""
    file.puts "CW.new do"
    file.puts "# TODO:  #{name}()"
    file.puts "  word_count 4"
    file.puts "end"
  end
end
