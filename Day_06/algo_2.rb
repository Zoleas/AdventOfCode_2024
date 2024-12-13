TEST = false
path = TEST ? 'example_input.txt' : 'input.txt'

DIRECTIONS = [[-1, 0], [0, 1], [1, 0], [0, -1]]
DIRECTION_FLAGS = [1 << 0, 1 << 1, 1 << 2, 1 << 3]

def find_guard(map)
  map.each_with_index do |line, i|
    found = line.find_index('^')
    return [i, found] unless found.nil?
  end
end

def test_loop(map, guard)
  height = map.count
  width = map.first.count
  while true do
    char = map[guard[:position][0]][guard[:position][1]]
    if char.is_a?(String)
      map[guard[:position][0]][guard[:position][1]] = DIRECTION_FLAGS[guard[:direction_index]]
    else
      if (char & DIRECTION_FLAGS[guard[:direction_index]]).positive?
        return true
      end
      map[guard[:position][0]][guard[:position][1]] = char | DIRECTION_FLAGS[guard[:direction_index]]
    end
    direction = DIRECTIONS[guard[:direction_index]]
    new_position = [guard[:position][0] + direction[0], guard[:position][1] + direction[1]]
    return false unless (0...height).include?(new_position[0]) && (0...width).include?(new_position[1])
    if map[new_position[0]][new_position[1]] == '#'
      guard[:direction_index] = (guard[:direction_index] + 1) % 4
    else
      guard[:position] = new_position
    end
  end
  p "OMG"
  false
end

def print_map(map, block_pos, guard_pos)
  p ''
  map.each_with_index do |line, i|
    s = line.map.with_index do |char, j|
        next 'O' if [i, j] == block_pos
        next '^' if [i, j] == guard_pos
        next char if char.is_a?(String)
        next '+' if (char & 5).positive? && (char & 10).positive?
        next '|' if (char & 5).positive?
        next '-' if (char & 10).positive?
        ' '
      end.join
    p s  
  end
  p ''
end

map = File.read(path).split("\n").map { _1.split('') }
height = map.count
width = map.first.count
guard = { position: find_guard(map), direction_index: 0 }

res = 0
p "Approx#{height * width} maps to test"
(0...height).each do |i|
  (0...width).each do |j|
    next if map[i][j] == '#'
    new_map = File.read(path).split("\n").map { _1.split('') }
    new_map[i][j] = '#'
    if test_loop(new_map, guard.dup)
      res += 1 
      # print_map(new_map, [i, j], guard[:position])
    end
  end
  p "#{(i+1) * width} maps tested. #{res} loops found"
end

p res
