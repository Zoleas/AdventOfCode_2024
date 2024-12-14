TEST = false
path = TEST ? 'example_input.txt' : 'input.txt'

STEPS = 100
WIDTH = TEST ? 11 : 101
HEIGHT = TEST ? 7 : 103

robots = File.read(path).split("\n").map do |robot|
  robot[2...robot.length].split(' v=').map { _1.split(',').map(&:to_i) }
end

def print_map(robots)
  map = Array.new(HEIGHT) { Array.new(WIDTH) { 0 } }
  robots.each do |robot|
    map[robot[0][1]][robot[0][0]] += 1
  end
  map.each do |line|
    p line.map { _1.zero? ? '.' : _1.to_s }.join
  end
  p ''
end

# p 'Initial state:'
# print_map(robots)

STEPS.times do
  robots.each do |robot|
    robot[0][0] = (robot[0][0] + robot[1][0]) % WIDTH
    robot[0][1] = (robot[0][1] + robot[1][1]) % HEIGHT
  end
end

# p "After #{STEPS} seconds:"
# print_map(robots)

map = Array.new(HEIGHT) { Array.new(WIDTH) { 0 } }
robots.each do |robot|
  map[robot[0][1]][robot[0][0]] += 1
end
p [
  map[0...(HEIGHT - 1) / 2].flat_map { |line| line[0...(WIDTH - 1) / 2] }.sum,
  map[0...(HEIGHT - 1) / 2].flat_map { |line| line[(WIDTH + 1) / 2...WIDTH] }.sum,
  map[(HEIGHT + 1) / 2...HEIGHT].flat_map { |line| line[0...(WIDTH - 1) / 2] }.sum,
  map[(HEIGHT + 1) / 2...HEIGHT].flat_map { |line| line[(WIDTH + 1) / 2...WIDTH] }.sum,
].reduce(1, &:*)

