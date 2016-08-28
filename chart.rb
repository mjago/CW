require 'gruff'

0.upto(112) do |count|
  puts "#{count}, #{100 + count * 8}"
end

def test_line_small_values
  @datasets = [
    [:narrow, [0.0,0.198,0.156,0.356,0.333,0.356,0.227,0.255,0.317,0.409,0.402,0.393,0.343,0.109,0.305,0.428,0.456,0.392,0.242,0.419,0.296,0.467,0.585,0.458,0.454,0.253,0.286,0.762,0.672,0.595,0.577,0.443,0.275,0.603,0.81,0.909,0.716,0.632,0.264,1.368,1.356,1.352,1.221,1.155,2.182,4.018,4.095,3.919,4.933,5.584,5.78,5.78,5.543,4.931,3.782,3.318,1.608,0.637,1.861,1.339,1.371,1.275,1.098,0.647,0.619,0.952,0.932,0.786,0.814,0.366,0.384,0.567,0.599,0.771,0.425,0.478,0.881,0.519,0.485,0.566,0.331,0.25,0.159,0.325,0.403,0.526,0.381,0.206,0.236,0.25,0.339,0.393,0.289,0.26,0.311,0.187,0.287,0.32,0.269,0.324,0.409,0.514,0.242,0.282,0.251,0.405,0.471,0.225,0.201,0.366,0.241,0.271,0.306]],
    [:wide, [0.198,0.092,0.187,0.257,0.334,0.369,0.369,0.397,0.4,0.368,0.317,0.323,0.333,0.099,0.165,0.264,0.392,0.428,0.474,0.492,0.48,0.436,0.661,0.395,0.253,0.137,0.147,0.853,0.602,0.7,0.637,0.876,0.733,0.733,1.055,0.634,0.531,0.347,0.133,1.272,1.376,1.061,1.724,2.287,2.009,2.268,2.507,2.688,2.815,2.883,2.89,2.89,2.882,2.794,2.676,2.496,2.267,1.953,2.47,1.511,1.05,0.832,0.848,0.63,0.333,1.429,0.617,0.685,0.744,0.727,0.703,0.622,0.508,0.858,0.265,0.478,0.914,0.296,0.333,0.525,0.435,0.444,0.47,0.526,0.406,0.485,0.212,0.13,0.243,0.134,0.21,0.36,0.31,0.33,0.346,0.328,0.302,0.351,0.2,0.308,0.398,0.514,0.138,0.193,0.234,0.26,0.268,0.26,0.289,0.236,0.169,0.42,0.341]],
    [:v_narrow, [0.0,0.198,0.175,0.326,0.301,0.189,0.109,0.243,0.292,0.37,0.214,0.27,0.33,0.201,0.438,0.47,0.17,0.489,0.296,0.412,0.48,0.45,0.349,0.486,0.479,0.357,0.501,0.67,0.554,0.506,0.637,0.443,0.511,0.769,0.762,0.742,0.923,0.81,0.511,1.292,1.494,0.683,1.73,1.479,1.957,2.885,2.288,2.188,6.903,9.976,11.56,11.56,10.212,5.167,6.356,3.505,2.15,1.184,1.497,1.331,0.72,1.127,0.959,0.646,0.902,0.786,0.45,0.744,0.608,0.469,0.622,0.492,0.45,0.522,0.522,0.478,0.881,0.454,0.418,0.363,0.564,0.313,0.296,0.414,0.372,0.497,0.39,0.3,0.314,0.364,0.238,0.199,0.337,0.235,0.277,0.302,0.336,0.493,0.277,0.274,0.385,0.514,0.259,0.207,0.214,0.26,0.359,0.189,0.256,0.255,0.149,0.25,0.214]]
  ]

  g = Gruff::Line.new
  g.title = 'Different bin widths'
  @datasets.each do |data|
    g.hide_dots = true
    g.data(data[0], data[1])
    g.labels = {0 => '100', 50 => '500', 112 => '1000'}
    end
  g.write('test/output/different_bin_widths.png')

  g = Gruff::Line.new(400)
  g.title = 'Different bin widths'
  g.hide_dots = true
  @datasets.each do |data|
    g.data(data[0], data[1])
    g.labels = {0 => '100'}
  end
  g.write('test/output/different_bin_widths_small.png')
end

test_line_small_values
