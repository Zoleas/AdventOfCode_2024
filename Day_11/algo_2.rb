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

def process(stones, remaining_steps)
  return stones.count if remaining_steps.zero?
  if stones.count == 1
    cached = @memo[stones.first] || Hash.new
    if cached.key?(remaining_steps)
      @hits += 1
      return cached[remaining_steps]
    end
    new_stones = blink(stones.first)
    cached[remaining_steps] = process(new_stones, remaining_steps - 1)
    @memo[stones.first] = cached
    return cached[remaining_steps]
  end
  process(stones[0...1], remaining_steps) + process(stones[1...stones.count], remaining_steps)
end

res = process(stones, 75)

p "values cached: #{@memo.values.sum { _1.values.count }}"
p "cache hits: #{@hits}"

p res
