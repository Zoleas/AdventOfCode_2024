TEST = false
path = TEST ? 'example_input.txt' : 'input.txt'

stones = File.read(path).split.map(&:to_i)

@memo = Hash.new
@hits = 0

def blink(stone)
  if stone.zero?
    [1]
  elsif stone.to_s.length.even?
    chars = stone.to_s
    [chars[0...(chars.length / 2)].to_i, chars[(chars.length / 2)...chars.length].to_i]
  else
    [stone * 2024]
  end
end

def process(stones, step, number_of_steps)
  return stones.count if step == number_of_steps
  if stones.count == 1
    remaining_steps = number_of_steps - step
    cached = @memo[stones.first] || Hash.new
    if cached.key?(remaining_steps)
      @hits += 1
      return cached[remaining_steps]
    end
    new_stones = blink(stones.first)
    cached[remaining_steps] = process(new_stones, step + 1, number_of_steps)
    @memo[stones.first] = cached
    return cached[remaining_steps]
  end
  process(stones[0...1], step, number_of_steps) + process(stones[1...stones.count], step, number_of_steps)
end

res = process(stones, 0, 75)

p "values cached: #{@memo.values.sum { _1.values.count }}"
p "cache hits: #{@hits}"

p res
