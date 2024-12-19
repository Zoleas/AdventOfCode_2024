require 'rb_heap'

TEST = true
path = TEST ? 'example_input.txt' : 'input.txt'

towels, patterns = File.read(path).split("\n\n")

towels = towels.split(', ')
patterns = patterns.split("\n")
max_towel_length = towels.map(&:length).max

towels_hash = towels.reduce(Hash.new) do |hash, towel|
  stripes = towel.chars
  leaf = hash
  stripes.each do |stripe|
    leaf[stripe] = { exist: false } unless leaf.key?(stripe)
    leaf = leaf[stripe]
  end
  leaf[:exist] = true
  hash
end

def test(pattern, towels_hash, max_length)
  pattern_chars = pattern.chars
  already_found = Array.new(pattern_chars.count) { false }
  (0...pattern_chars.count).each do |index|
    max_length_to_search = [index + 1, max_length].min
    already_found[index] = (1..max_length_to_search).any? do |number_of_chars|
      rest_is_good = index - number_of_chars >= 0 ? already_found[index - number_of_chars] : true
      next false unless rest_is_good
      search = pattern_chars[(pattern_chars.count - index - 1)...(pattern_chars.count - index - 1 + number_of_chars)]
      found = towels_hash.dig(*search, :exist)
      found
    end
  end
  already_found.last
end

res = patterns.filter { test(_1, towels_hash, max_towel_length) }.count
puts "Possible patterns: #{res}"