TEST = false
path = TEST ? 'example_input.txt' : 'input.txt'

SIZE = TEST ? 7 : 71
BYTES_TO_FALL = TEST ? 12 : 1024
MOVES = [[0, 1], [1, 0], [0, -1], [-1, 0]]

falling_bytes = File.read(path).split("\n").map { _1.split(',').map(&:to_i) }
map = Array.new(SIZE) { Array.new(SIZE) { Array.new(2) { |i| i.zero? ? nil : true } } }

def print_map(map)
  puts 'map'
  map.each { |line| puts line.map { |(score, pass)| pass ? '.' : '#' }.join }
  puts ''
end

BYTES_TO_FALL.times do |byte_index|
  byte = falling_bytes[byte_index]
  map[byte[1]][byte[0]][1] = false
end

print_map(map)

start = [0, 0]
map[0][0][0] = 0
finish = [SIZE - 1, SIZE - 1]

to_do = [start]

current = nil
loop do
  from = to_do.shift
  current = map[from[0]][from[1]][0]
  break if from == finish
  MOVES.each do |(yOffset, xOffset)|
    y = from[0] + yOffset
    x = from[1] + xOffset
    next unless (0...SIZE).include?(x) && (0...SIZE).include?(y)
    next unless map[y][x][1]
    next unless map[y][x][0].nil?
    map[y][x][0] = current + 1
    to_do << [y, x]
  end
end

print_map(map)

puts "Number of steps needed: #{current}"
