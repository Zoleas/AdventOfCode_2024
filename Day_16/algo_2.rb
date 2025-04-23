# frozen_string_literal: true

require 'rb_heap'

TEST = false
path = TEST ? 'example_input.txt' : 'input.txt'

module Direction
  UP = 0
  LEFT = 1
  DOWN = 2
  RIGHT = 3
  ALL = [UP, LEFT, DOWN, RIGHT].freeze
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

to_do = Heap.new { |a, b| a.first < b.first }
to_do << [0, start[0], start[1], Direction::RIGHT, [start[0], start[1], Direction::RIGHT]]

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

loop do
  current_value, y, x, dir, from = to_do.pop
  existing_value = already_computed[y][x][dir]
  next if !existing_value.nil? && existing_value[0] < current_value

  array = !existing_value.nil? && existing_value[0] == current_value ? existing_value : [current_value]
  already_computed[y][x][dir] = [*array, from].uniq if current_value.positive?
  break if finish == [y, x]

  forward = neighbor(y, x, dir)
  new_from = [y, x, dir]
  to_do << [current_value + 1, forward[0], forward[1], dir, new_from] unless map[forward[0]][forward[1]] == '#'
  to_do << [current_value + 1000, y, x, (dir + 1) % 4, new_from]
  to_do << [current_value + 1000, y, x, (dir + 3) % 4, new_from]
end

to_do = already_computed[finish[0]][finish[1]].compact.map { _1[1] }
map[finish[0]][finish[1]] = 'O'

until to_do.empty?
  y, x, dir = to_do.pop
  computed = already_computed[y][x][dir]
  map[y][x] = 'O'
  next if start == [y, x]

  computed[1...computed.count].each { |from| to_do << from }
end

# map.each { |line| puts line.join }

p "Number of tiles: #{map.sum { |line| line.filter { _1 == 'O' }.count }}"
