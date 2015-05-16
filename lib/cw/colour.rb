# ==========================================
#   Unity Project - A Test Framework for C
#   Copyright (c) 2007 Mike Karlesky, Mark VanderVoord, Greg Williams
#   [Released under MIT License. Please refer to license.txt for details]
# ==========================================

if RUBY_PLATFORM =~/(win|w)32$/
  begin
    require 'Win32API'
  rescue LoadError
    puts "ERROR! \"Win32API\" library not found"
    puts "\"Win32API\" is required for colour on a windows machine"
    puts "  try => \"gem install Win32API\" on the command line"
    puts
  end
  # puts
  # puts 'Windows Environment Detected...'
  # puts 'Win32API Library Found.'
  # puts
end

class Colour
  def initialize
    if RUBY_PLATFORM =~/(win|w)32$/
      get_std_handle = Win32API.new("kernel32", "GetStdHandle", ['L'], 'L')
      @set_console_txt_attrb =
        Win32API.new("kernel32","SetConsoleTextAttribute",['L','N'], 'I')
      @hout = get_std_handle.call(-11)
    end
  end

  def change_to(new_colour)
    if RUBY_PLATFORM =~/(win|w)32$/
      @set_console_txt_attrb.call(@hout,self.win32_colour(new_colour))
    else
      "\033[30;#{posix_colour(new_colour)};22m"
    end
  end

  def win32_colour(colour)
    case colour
    when :black then 0
    when :dark_blue then 1
    when :dark_green then 2
    when :dark_cyan then 3
    when :dark_red then 4
    when :dark_purple then 5
    when :dark_yellow, :narrative then 6
    when :default_white, :default, :dark_white then 7
    when :silver then 8
    when :blue then 9
    when :green, :success then 10
    when :cyan, :output then 11
    when :red, :failure then 12
    when :purple then 13
    when :yellow then 14
    when :white then 15
    else
      0
    end
  end

  def posix_colour(colour)
    # ANSI Escape Codes - Foreground colors
    # | Code | Color                     |
    # | 39   | Default foreground color  |
    # | 30   | Black                     |
    # | 31   | Red                       |
    # | 32   | Green                     |
    # | 33   | Yellow                    |
    # | 34   | Blue                      |
    # | 35   | Magenta                   |
    # | 36   | Cyan                      |
    # | 37   | Light gray                |
    # | 90   | Dark gray                 |
    # | 91   | Light red                 |
    # | 92   | Light green               |
    # | 93   | Light yellow              |
    # | 94   | Light blue                |
    # | 95   | Light magenta             |
    # | 96   | Light cyan                |
    # | 97   | White                     |

    case colour
    when :black then 30
    when :red, :failure then 31
    when :green, :success then 32
    when :yellow then 33
    when :blue, :narrative then 34
    when :purple, :magenta then 35
    when :cyan, :output then 36
    when :white, :default_white then 37
    when :default then 39
    when :dark_gray     then 90  # Dark gray
    when :light_red     then 91  # Light red
    when :light_green   then 92  # Light green
    when :light_yellow  then 93  # Light yellow
    when :light_blue    then 94  # Light blue
    when :light_magenta then 95  # Light magenta
    when :light_cyan    then 96  # Light cyan
    when :White         then 97  # White

    else
      39
    end
  end

  def out_c(mode, colour, str, out = :stdout)
    buf = case out
          when :stdout
            $stdout
          else
            out = out
          end
    case RUBY_PLATFORM
    when /(win|w)32$/
      change_to(colour)
      buf.puts str if mode == :puts
      buf.print str if mode == :print
      change_to(:default_white)
    else
      buf.puts("#{change_to(colour)}#{str}\033[0m") if mode == :puts
      $stdout.print("#{change_to(colour)}#{str}\033[0m") if mode == :print
    end
  end
end # Colour

def colour_puts(role,str, out = :stdout)  Colour.new.out_c(:puts, role, str, out)  end
def colour_print(role,str, out = :stdout) Colour.new.out_c(:print, role, str, out) end
