# frozen_string_literal: true

TEST = false
path = TEST ? 'example_input.txt' : 'input.txt'

stones = File.read(path).split.map(&:to_i)

def blink(stones)
  new_stones = []
  stones.each do |stone|
    if stone.zero?
      new_stones << 1
    elsif stone.to_s.length.even?
      chars = stone.to_s
      new_stones << chars[0...(chars.length / 2)].to_i
      new_stones << chars[(chars.length / 2)...chars.length].to_i
    else
      new_stones << stone * 2024
    end
  end
  new_stones
end

25.times do |_i|
  stones = blink(stones)
end

p stones.count
