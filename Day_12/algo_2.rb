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
  rows = region.sort do |e1, e2|
    main_sort = e1[0] <=> e2[0]
    main_sort.zero? ? e1[1] <=> e2[1] : main_sort
  end.group_by{ _1[0]}.values

  columns = region.sort do |e1, e2|
    main_sort = e1[1] <=> e2[1]
    main_sort.zero? ? e1[0] <=> e2[0] : main_sort
  end.group_by{ _1[1]}.values

  sides = 0

  sides += rows.reduce(0) do |sum, row|
    linked_top = false
    linked_bottom = false
    previous_j = nil
    new_sides = row.reduce(0) do |sub_sum, (i, j)|
      if previous_j != j - 1
        linked_top = false
        linked_bottom = false
      end
      previous_j = j
      t = 0
      if region.include?([i - 1, j])
        linked_top = false
      else
        t +=1 unless linked_top
        linked_top = true
      end
      if region.include?([i + 1, j])
        linked_bottom = false
      else
        t +=1 unless linked_bottom
        linked_bottom = true
      end
      sub_sum + t
    end
    sum + new_sides
  end

  sides += columns.reduce(0) do |sum, column|
    linked_left = false
    linked_right = false
    previous_i = nil
    new_sides = column.reduce(0) do |sub_sum, (i, j)|
      if previous_i != i - 1
        linked_left = false
        linked_right = false
      end
      previous_i = i
      t = 0
      if region.include?([i, j - 1])
        linked_left = false
      else
        t +=1 unless linked_left
        linked_left = true
      end
      if region.include?([i, j + 1])
        linked_right = false
      else
        t +=1 unless linked_right
        linked_right = true
      end
      sub_sum + t
    end
    sum + new_sides
  end
  sides * region.count
end


p regions.sum { price(_1) }

