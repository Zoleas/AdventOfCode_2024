# frozen_string_literal: true

TEST = false
path = TEST ? 'example_input.txt' : 'input.txt'

SIZE = TEST ? 7 : 71
MOVES = [[0, 1], [1, 0], [0, -1], [-1, 0]].freeze

falling_bytes = File.read(path).split("\n").map { _1.split(',').map(&:to_i) }

def print_map(map)
  puts 'map'
  map.each { |line| puts line.map { |pass| pass ? '.' : '#' }.join }
  puts ''
end

def possible(map)
  start = [0, 0]
  finish = [SIZE - 1, SIZE - 1]
  scores = Array.new(SIZE) { Array.new(SIZE) { nil } }
  scores[0][0] = 0

  to_do = [start]

  current = nil
  loop do
    from = to_do.shift
    return false if from.nil?

    current = scores[from[0]][from[1]]
    return true if from == finish

    MOVES.each do |(yOffset, xOffset)|
      y = from[0] + yOffset
      x = from[1] + xOffset
      next unless (0...SIZE).include?(x) && (0...SIZE).include?(y)
      next unless map[y][x]
      next unless scores[y][x].nil?

      scores[y][x] = current + 1
      to_do << [y, x]
    end
  end
end

success_index = 0
fail_index = falling_bytes.count - 1
loop do
  break if success_index == fail_index - 1

  try_index = (fail_index + 1 + success_index) / 2
  map = Array.new(SIZE) { Array.new(SIZE) { true } }
  (0..try_index).each do |byte_index|
    byte = falling_bytes[byte_index]
    map[byte[1]][byte[0]] = false
  end
  if possible(map)
    success_index = try_index
  else
    fail_index = try_index
  end
end

# print_map(map)

puts "First impossible byte: #{falling_bytes[fail_index]}"
