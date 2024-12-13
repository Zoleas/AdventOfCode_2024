TEST = false
path = TEST ? 'example_input.txt' : 'input.txt'

DIRECTIONS = [[-1, 0], [0, 1], [1, 0], [0, -1]]

def find_guard(map)
  map.each_with_index do |line, i|
    found = line.find_index('^')
    return [i, found] unless found.nil?
  end
end

map = File.read(path).split("\n").map { _1.split('') }
height = map.count
width = map.first.count
guard = { position: find_guard(map), direction_index: 0 }

while true do
  map[guard[:position][0]][guard[:position][1]] = 'X'
  direction = DIRECTIONS[guard[:direction_index]]
  new_position = [guard[:position][0] + direction[0], guard[:position][1] + direction[1]]
  break unless (0...height).include?(new_position[0]) && (0...width).include?(new_position[1])
  if map[new_position[0]][new_position[1]] == '#'
    guard[:direction_index] = (guard[:direction_index] + 1) % 4
  else
    guard[:position] = new_position
  end
end

res = map.reduce(0) do |sum, line|
  sum + line.reduce(0) { |sub_sum, e| sub_sum + (e == 'X' ? 1 : 0) }
end

p res
