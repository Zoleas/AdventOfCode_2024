TEST = false
path = TEST ? 'example_input.txt' : 'input.txt'

res = File.read(path).scan(/mul\((\d{1,3}),(\d{1,3})\)/).sum { |a, b| a.to_i * b.to_i }

p res
