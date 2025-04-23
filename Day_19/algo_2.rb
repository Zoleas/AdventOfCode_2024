# frozen_string_literal: true

require 'rb_heap'

TEST = false
path = TEST ? 'example_input.txt' : 'input.txt'

towels, patterns = File.read(path).split("\n\n")

towels = towels.split(', ')
patterns = patterns.split("\n")
max_towel_length = towels.map(&:length).max

towels_hash = towels.each_with_object({}) do |towel, hash|
  stripes = towel.chars
  leaf = hash
  stripes.each do |stripe|
    leaf[stripe] = { exist: false } unless leaf.key?(stripe)
    leaf = leaf[stripe]
  end
  leaf[:exist] = true
end

def test(pattern, towels_hash, max_length)
  pattern_chars = pattern.chars
  already_found = Array.new(pattern_chars.count) { 0 }
  (0...pattern_chars.count).each do |index|
    max_length_to_search = [index + 1, max_length].min
    already_found[index] = (1..max_length_to_search).map do |number_of_chars|
      rest_is_good = index - number_of_chars >= 0 ? already_found[index - number_of_chars] : 1
      next 0 if rest_is_good.zero?

      search = pattern_chars[(pattern_chars.count - index - 1)...(pattern_chars.count - index - 1 + number_of_chars)]
      found = towels_hash.dig(*search, :exist)
      found ? rest_is_good : 0
    end.sum
  end
  already_found.last
end

res = patterns.map { test(_1, towels_hash, max_towel_length) }.sum
puts "Possible patterns: #{res}"
