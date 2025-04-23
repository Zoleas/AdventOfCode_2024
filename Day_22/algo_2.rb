# frozen_string_literal: true

TEST = false
path = TEST ? 'example_input.txt' : 'input.txt'

PRUNE_MASK = 0b111111111111111111111111
PRUNE_MODULO = 16_777_216

codes = File.read(path).split("\n").map(&:to_i)

def next_code(code)
  tmp = code << 6
  code ^= tmp
  code &= PRUNE_MASK
  tmp = code >> 5
  code ^= tmp
  code &= PRUNE_MASK
  tmp = code << 11
  code ^= tmp
  code & PRUNE_MASK
end

def compute_codes(code, times)
  codes = Array.new(times)
  codes[0] = code
  (1...codes.count).each do |i|
    previous_code = i.zero? ? code : codes[i - 1]
    codes[i] = next_code(previous_code)
  end
  codes
end

def compute_price_diffs(codes)
  prices = codes.map { _1 % 10 }
  diffs = prices.map.with_index { |price, i| i.zero? ? nil : price - prices[i - 1] }
  [prices, diffs]
end

def compute_sequences(prices, diffs)
  sequences = {}
  (4...prices.count).each do |i|
    key = "#{diffs[i - 3]}#{diffs[i - 2]}#{diffs[i - 1]}#{diffs[i]}"
    sequences[key] = prices[i] unless sequences.key?(key)
  end
  sequences
end

puts 'Computing sequences...'

sequences = codes.map do |code|
  new_codes = compute_codes(code, 2001)
  prices, diffs = compute_price_diffs(new_codes)
  compute_sequences(prices, diffs)
end

puts 'Sequences computed'

all_keys = sequences.flat_map(&:keys).uniq

puts "#{all_keys.count} keys to try..."

values = all_keys.map do |key|
  sequences.reduce(0) do |sum, sequences_hash|
    sequences_hash.key?(key) ? sum + sequences_hash[key] : sum
  end
end

puts 'Done'

puts values.max
