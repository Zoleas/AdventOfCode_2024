TEST = false
path = TEST ? 'example_input.txt' : 'input.txt'

@input = File.read(path).split("\n").map { _1.split('') }
@width = @input[0].count
@height = @input.count

OFFSETS = [[1, 1], [1, -1], [-1, -1], [-1, 1]]

def search(x, y, xOffset, yOffset)
  x1 = x + xOffset
  y1 = y + yOffset
  x2 = x - xOffset
  y2 = y - yOffset
  return 0 unless (0...@width).include?(x1) && (0...@height).include?(y1)
  return 0 unless (0...@width).include?(x2) && (0...@height).include?(y2)
  return 0 unless @input[y1][x1] == 'M' && @input[y2][x2] == 'S'
  return 1
end

res = 0
(0...@height).each do |y|
  (0...@width).each do |x|
    if @input[y][x] == 'A'
      mas = OFFSETS.reduce(0) { |sum, offsets| sum + search(x, y, offsets[0], offsets[1]) }
      res += 1 if mas >= 2
    end
  end
end

p res
