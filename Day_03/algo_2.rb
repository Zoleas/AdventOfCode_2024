TEST = false
path = TEST ? 'example_input.txt' : 'input.txt'

enabled = true
res = File.read(path).scan((/(don't)\(\)|(do)\(\)|mul\((\d{1,3}),(\d{1,3})\)/)).sum do |disable, enable, a, b|
  if disable
    enabled = false
  elsif enable
    enabled = true
  elsif enabled
    next a.to_i * b.to_i
  end
  0
end

p res
