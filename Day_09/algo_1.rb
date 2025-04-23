# frozen_string_literal: true

TEST = false
path = TEST ? 'example_input.txt' : 'input.txt'

input = File.read(path).chars.map(&:to_i)

disk = []
file_id = 0
is_free_space = false
input.each do |value|
  if is_free_space
    value.times { disk << '.' }
  else
    value.times { disk << file_id }
    file_id += 1
  end
  is_free_space = !is_free_space
end

first_free_space = 0
(1...disk.count).reverse_each do |index|
  char = disk[index]
  next if char == '.'

  new = disk[first_free_space...index].find_index('.')
  break if new.nil?

  first_free_space += new
  disk[first_free_space], disk[index] = disk[index], disk[first_free_space]
end

disk.filter! { |char| char != '.' }
res = disk.each_with_index.reduce(0) do |sum, (char, index)|
  sum + char * index
end

p res
