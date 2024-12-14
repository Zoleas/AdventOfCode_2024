require 'colorize'

TEST = false
path = TEST ? 'example_input.txt' : 'input.txt'

STEPS = 100
WIDTH = TEST ? 11 : 101
HEIGHT = TEST ? 7 : 103

robots = File.read(path).split("\n").map do |robot|
  robot[2...robot.length].split(' v=').map { _1.split(',').map(&:to_i) }
end

def print_map(robots, neighbors_map)
  map = Array.new(HEIGHT) { Array.new(WIDTH) { 0 } }
  robots.each do |robot|
    map[robot[0][1]][robot[0][0]] += 1
  end
  map.each do |line|
    p line.map { |value| value.zero? ? ' ' : '#' }.join
  end
end

step = 0
input = ''
while input.strip != 'q' do
  neighbors_map = nil
  loop do
    robots.each do |robot|
      robot[0][0] = (robot[0][0] + robot[1][0]) % WIDTH
      robot[0][1] = (robot[0][1] + robot[1][1]) % HEIGHT
    end
    step += 1

    neighbors_map = Array.new(HEIGHT) { Array.new(WIDTH) { 0 } }
    robots.map(&:first).uniq.each do |robot|
      x, y = robot
      [[x - 1, y - 1], [x - 1, y], [x - 1, y + 1], [x, y + 1], [x + 1, y + 1], [x + 1, y], [x + 1, y - 1], [x, y - 1]].each do |a, b|
        neighbors_map[b][a] += 1 if (0...WIDTH).include?(a) && (0...HEIGHT).include?(b)
      end

    end
    break if neighbors_map.flatten.any? { _1 == 8 }   
  end
  p ''
  p "After #{step} seconds:"
  print_map(robots, neighbors_map)

  input = gets
end

