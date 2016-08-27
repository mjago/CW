SHOW_ALL = true
SHOW_TONE = true if SHOW_ALL
SHOW_N = true if SHOW_ALL
SHOW_BINWIDTH = true if SHOW_ALL
SHOW_COEFFS = true if SHOW_ALL

@sample_rate = 44100
#@sample_rate = 48000
#@sample_rate = 96000
#@sample_rate = 192000

def sample_period ; 1.0 / @sample_rate ; end
def k ; (0.5 + ((n * @tone) / @sample_rate)).to_i ; end
def w ; ((2 * Math::PI) / n) * k ; end
def n ; @sample_rate/@bin_width ; end
def cosine ; Math.cos(w) ; end
def sine ; Math.sin(w) ; end
def coeff ; 2 * cosine ; end
def bin_width(val) ; @bin_width = val ; end
def tone(val) ; @tone = val ; end
def n_delay_ms ; ((1.0/@sample_rate) * n * 1000); end
def centre_freq ; @sample_rate / n ; end
@data = [
  {tone: 400, bin_width: 40},
  {tone: 400, bin_width: 80},
  {tone: 450, bin_width: 45},
  {tone: 450, bin_width: 90},
  {tone: 500, bin_width: 50},
  {tone: 500, bin_width: 100},
  {tone: 550, bin_width: 55},
  {tone: 550, bin_width: 110},
  {tone: 600, bin_width: 60},
  {tone: 600, bin_width: 120},
  {tone: 700, bin_width: 70},
  {tone: 700, bin_width: 140},
  {tone: 800, bin_width: 80},
  {tone: 800, bin_width: 160},
  {tone: 900, bin_width: 90},
  {tone: 900, bin_width: 180},
  {tone: 1000, bin_width: 50},
  {tone: 1000, bin_width: 100},
]
puts "Calculator"
puts "----------"
puts
puts "Sample Rate: #{@sample_rate} Hz"
puts "Sample Period: #{sample_period * 1000000.0} usec"
puts
@data.each do |dat|
  puts "*   *   *   *   *   *   *   *"
  puts "Desired Tone: #{tone(tone dat[:tone])} Hz" if SHOW_TONE
  puts "Desired binwidth: #{bin_width dat[:bin_width]}" if SHOW_BINWIDTH
  puts "N value: #{n}" if SHOW_N
  puts "N delay: #{n_delay_ms} msec" if SHOW_N
  puts "(Sample Rate / N): #{@sample_rate.to_f / n.to_f}" if SHOW_N
  puts "Tone / (Sample rate / N): #{(@tone.to_f / (@sample_rate.to_f / n.to_f))} is multiple?" if SHOW_N
  puts "k: #{k}" if SHOW_COEFFS
  puts "w: #{w}" if SHOW_COEFFS
  puts "cosine: #{cosine}" if SHOW_COEFFS
  puts "sine: #{sine}" if SHOW_COEFFS
  puts "coeff: #{coeff}" if SHOW_COEFFS
  puts
end
