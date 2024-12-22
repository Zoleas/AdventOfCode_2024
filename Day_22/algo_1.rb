TEST = false
path = TEST ? 'example_input.txt' : 'input.txt'

PRUNE_MASK = 0b111111111111111111111111

codes = File.read(path).split("\n").map(&:to_i)

def next_code(code)
  tmp = code << 6
  code = code ^ tmp
  code = code & PRUNE_MASK
  tmp = code >> 5
  code = code ^ tmp
  code = code & PRUNE_MASK
  tmp = code << 11
  code = code ^ tmp
  code & PRUNE_MASK
end

res = codes.map do |code|
  2000.times do
    code = next_code(code)
  end
  code
end

puts res.sum
