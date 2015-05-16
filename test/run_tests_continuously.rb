#!/usr/bin/env ruby

system "rerun test/test_cw.rb -c --no-growl -n cw --pattern \"*.{rb}\""
system "reek lib/cw.rb lib/cw/words.rb  lib/cw/alphabet.rb  lib/cw/randomize.rb lib/cw/cw_dsl.rb  lib/cw/str.rb  lib/cw/cl.rb lib/cw/alphabet.rb lib/cw/cw_encode.rb lib/cw/cw_params.rb "
