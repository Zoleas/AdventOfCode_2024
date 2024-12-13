TEST = false
path = TEST ? 'example_input.txt' : 'input.txt'

@input = File.read(path).split("\n").map { _1.split('') }
@width = @input[0].count
@height = @input.count

OFFSETS = [[0, 1], [1, 1], [1,0], [1, -1], [0, -1], [-1, -1], [-1, 0], [-1, 1]]

def search(suffix, x, y, xOffset, yOffset)
  # p "searching #{suffix} with xOffset: #{xOffset}, yOffset: #{yOffset}"
  newX = x + xOffset
  newY = y + yOffset
  return 0 unless (0...@width).include?(newX) && (0...@height).include?(newY)
  return 0 unless @input[newY][newX] == suffix[0]
  # p "found #{suffix[0]} at [#{newX}, #{newY}]"
  return 1 if suffix.length == 1
  return search(suffix[1, suffix.length - 1], newX, newY, xOffset, yOffset)
end

res = 0
(0...@height).each do |y|
  (0...@width).each do |x|
    if @input[y][x] == 'X'
      # p "found X at [#{x}, #{y}]"
      res += OFFSETS.reduce(0) { |sum, offsets| sum + search('MAS', x, y, offsets[0], offsets[1]) }
    end
  end
end

p res
