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
res = list1.reduce(0) do |sum, e|
  sum + e * list2.find_all { |f| f == e }.size
end
p res
