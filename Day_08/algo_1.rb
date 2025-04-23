# frozen_string_literal: true

TEST = false
path = TEST ? 'example_input.txt' : 'input.txt'

map = File.read(path).split("\n").map(&:chars)
height = map.count
width = map.first.count

antennas = {}

map.each_with_index do |line, i|
  line.each_with_index do |char, j|
    if char != '.'
      antennas[char] ||= []
      antennas[char] << [i, j]
    end
  end
end

antinodes = []

antennas.each_value do |positions|
  (0...(positions.count - 1)).each do |i|
    ((i + 1)...positions.count).each do |j|
      a1 = positions[i]
      a2 = positions[j]
      vector = [a2[0] - a1[0], a2[1] - a1[1]]
      antinodes << [a2[0] + vector[0], a2[1] + vector[1]]
      antinodes << [a1[0] - vector[0], a1[1] - vector[1]]
    end
  end
end

antinodes = antinodes.uniq.filter { |position| (0...height).include?(position[0]) && (0...width).include?(position[1]) }

p antinodes.count
