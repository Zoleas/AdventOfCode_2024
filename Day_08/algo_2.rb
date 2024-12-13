TEST = false
path = TEST ? 'example_input.txt' : 'input.txt'

input = File.read(path).chars

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

antennas.values.each do |positions|
  (0...(positions.count - 1)).each do |i|
    ((i + 1)...positions.count).each do |j|
      a1 = positions[i]
      a2 = positions[j]
      vector = [a2[0] - a1[0], a2[1] - a1[1]]
      p = a1.dup
      while (0...height).include?(p[0]) && (0...width).include?(p[1])
        antinodes << p.dup
        p[0] -= vector[0]
        p[1] -= vector[1]
      end
      p = a2.dup
      while (0...height).include?(p[0]) && (0...width).include?(p[1])
        antinodes << p.dup
        p[0] += vector[0]
        p[1] += vector[1]
      end
    end
  end
end



antinodes = antinodes.uniq

p antinodes.count
