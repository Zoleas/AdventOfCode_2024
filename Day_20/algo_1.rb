TEST = false
path = TEST ? 'example_input.txt' : 'input.txt'

THRESHOLD = 100

module Direction
  UP = 0
  LEFT = 1
  DOWN = 2
  RIGHT = 3
  ALL = [UP, LEFT, DOWN, RIGHT]
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
    if map[forward[0]][forward[1]] != '#' && path_values[forward[0]][forward[1]].nil?
      path_values[forward[0]][forward[1]] = path_values[current[0]][current[1]] + 1
      current = forward
      break
    end
  end
end

cheats = Hash.new { |hash, key| Array.new }

path_values.each_with_index do |line, y|
  line.each_with_index do |time, x|
    next if time.nil?
    Direction::ALL.each do |dir1|
      move1 = neighbor(y, x, dir1)
      next unless y_range.include?(move1[0]) && x_range.include?(move1[1]) && path_values[move1[0]][move1[1]].nil?
      Direction::ALL.each do |dir2|
        move2 = neighbor(move1[0], move1[1], dir2)
        next unless y_range.include?(move2[0]) && x_range.include?(move2[1]) && !path_values[move2[0]][move2[1]].nil?
        time_saved = path_values[move2[0]][move2[1]] - time - 2
        cheats[time_saved] = cheats[time_saved] << [move1, move2] if time_saved.positive?
      end
    end
  end
end

number_of_good_cheats = cheats.keys.filter {_1 >= THRESHOLD}.reduce(0) do |sum, k|
  sum + cheats[k].count
end

puts "There are #{number_of_good_cheats} cheats that saves more than #{THRESHOLD} picoseconds."

