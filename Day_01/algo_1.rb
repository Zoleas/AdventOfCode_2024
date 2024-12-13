TEST = false
path = TEST ? 'example_input.txt' : 'input.txt'

list1 = []
list2 = []
File.read(path).split("\n").each do |line|
  a, b = line.split(' ').map(&:to_i)
  list1 << a
  list2 << b
end
list1.sort!
list2.sort!
res = (0...list1.size).sum do |i|
  (list2[i] - list1[i]).abs
end
p res
