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

file_index = disk.count - 1
while file_index.positive?
  file_index -= 1 while disk[file_index] == '.'
  file_end_index = file_index
  char = disk[file_index]
  file_index -= 1 while disk[file_index - 1] == char
  file_size = file_end_index - file_index
  free_space_index = 0
  while free_space_index < file_index
    unless disk[free_space_index] == '.'
      free_space_index += 1
      next
    end
    free_space_end_index = free_space_index + file_size
    bad_index = disk[free_space_index..free_space_end_index].find_index { |e| e != '.' }
    if bad_index.nil?
      disk[free_space_index..free_space_end_index], disk[file_index..file_end_index] = disk[file_index..file_end_index], disk[free_space_index..free_space_end_index]
      break
    else
      free_space_index += bad_index
    end
    
  end

  file_index -= 1
end

res = disk.each_with_index.reduce(0) do |sum, (char, index)|
  next sum if char == '.'

  sum + char * index
end

p res
