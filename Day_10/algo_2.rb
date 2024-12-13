TEST = false
path = TEST ? 'example_input.txt' : 'input.txt'

map = File.read(path).split("\n").map { _1.chars.map(&:to_i) }

origins = []

map.each_with_index do |line, i|
  line.each_with_index do |value, j|
    origins << [i, j] if value == 0
  end
end

def advance(map, origin, value)
  return [] unless (0...map.count).include?(origin[0]) && (0...map.first.count).include?(origin[1])
  return [] unless value == map[origin[0]][origin[1]]
  return [origin] if value == 9
  next_value = value + 1
  [
    advance(map, [origin[0] + 1, origin[1]], next_value),
    advance(map, [origin[0] - 1, origin[1]], next_value),
    advance(map, [origin[0], origin[1] + 1], next_value),
    advance(map, [origin[0], origin[1] - 1], next_value)
].flatten(1)
end

res = origins.reduce(Hash.new) do |total, origin|
  total[origin.to_s] = advance(map, origin, 0)
  total
end

# res.entries.each { |k, v| p "#{k}: #{v}" }

p res.values.sum(&:count)
