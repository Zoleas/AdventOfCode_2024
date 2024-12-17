require 'rb_heap'

TEST = false
path = TEST ? 'example_input.txt' : 'input.txt'

module Direction
  UP = 0
  LEFT = 1
  DOWN = 2
  RIGHT = 3
end

map = File.read(path).split("\n").map(&:chars)
start = nil
finish = nil
already_computed = Array.new(map.count) { Array.new(map.first.count) { Array.new(4) { nil } } }

map.each_with_index do |line, y|
  line.each_with_index do |char, x|
    start = [y, x] if char == 'S'
    finish = [y, x] if char == 'E'
  end
end

to_do = Heap.new{ |a, b| a.first < b.first }
to_do << [0, start[0], start[1], Direction::RIGHT]

def neighbor(y, x, dir)
  case dir
  when Direction::UP
    [y - 1, x]
  when Direction::LEFT
    [y, x - 1]
  when Direction::DOWN
    [y + 1, x]
  when Direction::RIGHT
    [y, x + 1]
  end
end

res = 0

loop do
  current_value, y, x, dir = to_do.pop
  if [y, x] == finish
    res = current_value
    break
  end
  existing_value = already_computed[y][x][dir]
  next if !existing_value.nil? && existing_value <= current_value
  already_computed[y][x][dir] = current_value
  forward = neighbor(y, x, dir)
  to_do << [current_value + 1, forward[0], forward[1], dir] unless map[forward[0]][forward[1]] == '#'
  to_do << [current_value + 1000, y, x, (dir + 1) % 4]
  to_do << [current_value + 1000, y, x, (dir + 3) % 4]
end

p res
