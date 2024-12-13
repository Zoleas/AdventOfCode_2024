TEST = false
path = TEST ? 'example_input.txt' : 'input.txt'

@field = File.read(path).split.map{ _1.chars }
regions = []
@affected = Set.new

@height = @field.count
@width = @field.first.count

def find_region(from:)
  plot = @field[from[0]][from[1]]
  region = []
  stack = Set.new([from])
  visited = Set.new
  while !stack.empty?
    e = stack.first
    stack.delete(e)
    visited << e
    if @field[e[0]][e[1]] == plot
      region << e
      @affected << e
      [[e[0] + 1, e[1]], [e[0] - 1, e[1]], [e[0], e[1] + 1], [e[0], e[1] - 1]].each do |(i, j)|
        if !visited.include?([i, j]) && (0...@height).include?(i) && (0...@width).include?(j) 
          stack << [i, j] 
        end
      end
    end
  end
  region
end

(0...@height).each do |i|
  (0...@width).each do |j|
    next if @affected.include?([i, j])
    regions << find_region(from: [i, j])
  end  
end

def price(region)
  perimeter = region.reduce(0) do |sum, (i, j)|
    sum + 4 - [[i + 1, j], [i - 1, j], [i, j + 1], [i, j - 1]].filter { region.include?(_1) }.count
  end
  perimeter * region.count
end

# regions.each { p "A region of #{@field[_1[0][0]][_1[0][1]]} plants with price #{price(_1)}" }

p regions.sum { price(_1) }

