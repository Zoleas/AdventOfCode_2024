# frozen_string_literal: true

TEST = false
path = TEST ? 'example_input.txt' : 'input.txt'

THRESHOLD = TEST ? 50 : 100
MAX_CHEAT_TIME = 20

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
path_values = Array.new(map.count) { Array.new(map.first.count) { nil } }

map.each_with_index do |line, y|
  line.each_with_index do |char, x|
    start = [y, x] if char == 'S'
    finish = [y, x] if char == 'E'
  end
end

y_range = (0...map.count)
x_range = (0...map.first.count)

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

current = start
path_values[start[0]][start[1]] = 0

while current != finish
  Direction::ALL.each do |dir|
    forward = neighbor(current[0], current[1], dir)
    next unless map[forward[0]][forward[1]] != '#' && path_values[forward[0]][forward[1]].nil?

    path_values[forward[0]][forward[1]] = path_values[current[0]][current[1]] + 1
    current = forward
    break
  end
end

cheats = Hash.new { |_hash, _key| Set.new }

path_values.each_with_index do |line, y|
  line.each_with_index do |time, x|
    next if time.nil?

    tmp = 0
    ((y - MAX_CHEAT_TIME)..(y + MAX_CHEAT_TIME)).each do |end_y|
      ((x - MAX_CHEAT_TIME)..(x + MAX_CHEAT_TIME)).each do |end_x|
        next unless y_range.include?(end_y) && x_range.include?(end_x) && !path_values[end_y][end_x].nil?

        distance = (end_y - y).abs + (end_x - x).abs
        next unless (2..MAX_CHEAT_TIME).include?(distance) && map[end_y][end_x] != '#'

        tmp += 1
        time_saved = path_values[end_y][end_x] - time - distance
        cheats[time_saved] = cheats[time_saved] << [[y, x], [end_y, end_x]] if time_saved.positive?
      end
    end
  end
end

number_of_good_cheats = cheats.keys.filter { _1 >= THRESHOLD }.reduce(0) do |sum, k|
  sum + cheats[k].count
end

cheats.keys.sort.filter { _1 >= THRESHOLD }.each do |k|
  puts "There are #{cheats[k].count} cheats that save #{k} picoseconds."
end

puts "There are #{number_of_good_cheats} cheats that saves more than #{THRESHOLD} picoseconds."
