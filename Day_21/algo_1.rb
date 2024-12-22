TEST = false
path = TEST ? 'example_input.txt' : 'input.txt'

codes = File.read(path).split("\n")

module Direction
  UP = '^'.freeze
  LEFT = '<'.freeze
  DOWN = 'v'.freeze
  RIGHT = '>'.freeze
end

numeric_pad = {
  '7' => [0, 0],
  '8' => [0, 1],
  '9' => [0, 2],
  '4' => [1, 0],
  '5' => [1, 1],
  '6' => [1, 2],
  '1' => [2, 0],
  '2' => [2, 1],
  '3' => [2, 2],
  '0' => [3, 1],
  'A' => [3, 2],
  'panic' => [3, 0],
}

directional_pad = {
  Direction::UP => [0, 1],
  Direction::LEFT => [1, 0],
  Direction::DOWN => [1, 1],
  Direction::RIGHT => [1, 2],
  'A' => [0, 2],
  'panic' => [0, 0],
}

def neighbor(y, x, dir)
  case dir
  when Direction::UP
    [y - 1, x]
  when Direction::LEFT
    [y, x - 1]
  when Direction::DOWN
    [y + 1, x]
  when Direction::RIGHT
    [y, x + 1]
  end
end

def path(start, finish, panic)
  return [''] if start == finish
  directions_needed = []
  directions_needed << Direction::UP if finish[0] < start[0]
  directions_needed << Direction::LEFT if finish[1] < start[1]
  directions_needed << Direction::DOWN if finish[0] > start[0]
  directions_needed << Direction::RIGHT if finish[1] > start[1]
  directions_needed.reduce(Array.new) do |paths, dir|
    next_button = neighbor(start[0], start[1], dir)
    unless next_button == panic
      paths << path(next_button, finish, panic).map { dir + _1 }
    end
    paths
  end.flatten
end

def translate(keypad, code)
  current = 'A'
  paths = ['']
  code.chars.each do |digit|
    new_paths = path(keypad[current], keypad[digit], keypad['panic'])
    paths = paths.flat_map do |path|
      new_paths.map { path + _1 + 'A' }
    end
    current = digit
  end
  paths
end

res = codes.map do |code|
  sequences = [code]
  p "Translating code: #{code}"
  3.times do |i|
    keypad = i.zero? ? numeric_pad : directional_pad
    sequences = sequences.flat_map { |sequence| translate(keypad, sequence) }
  p "Step #{i + 1} done"
  end
  shortest = sequences.min { |a, b| a.length <=> b.length }
  p "code: #{code} translated"
  code.to_i * shortest.length
end

puts res.sum
