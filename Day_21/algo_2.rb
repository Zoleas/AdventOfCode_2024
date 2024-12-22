TEST = false
path = TEST ? 'example_input.txt' : 'input.txt'

codes = File.read(path).split("\n")

module Direction
  UP = '^'.freeze
  LEFT = '<'.freeze
  DOWN = 'v'.freeze
  RIGHT = '>'.freeze
end

NUMBER_OF_DIRECTIONAL_PADS = TEST ? 2 : 25

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

@memo = Array.new(NUMBER_OF_DIRECTIONAL_PADS + 1) { Array.new(14) { nil } }

def memoized(pad_number, move_number, &compute_bloc)
  value = @memo[pad_number][move_number] || yield
  @memo[pad_number][move_number] = value
  value
end

def price(from, to, pad_number)
  return 1 if pad_number.zero?
  case [from, to]
  when ['A', Direction::UP], [Direction::RIGHT, Direction::DOWN], [Direction::DOWN, Direction::LEFT]
    memoized(pad_number, 0) { price('A', Direction::LEFT, pad_number - 1) + price(Direction::LEFT, 'A', pad_number - 1) }
  when [Direction::UP, 'A'], [Direction::DOWN, Direction::RIGHT], [Direction::LEFT, Direction::DOWN]
    memoized(pad_number, 1) { price('A', Direction::RIGHT, pad_number - 1) + price(Direction::RIGHT, 'A', pad_number - 1) }
  when [Direction::RIGHT, Direction::LEFT]
    memoized(pad_number, 2) { price('A', Direction::LEFT, pad_number - 1) + price(Direction::LEFT, Direction::LEFT, pad_number - 1) + price(Direction::LEFT, 'A', pad_number - 1) }
  when [Direction::LEFT, Direction::RIGHT]
    memoized(pad_number, 3) { price('A', Direction::RIGHT, pad_number - 1) + price(Direction::RIGHT, Direction::RIGHT, pad_number - 1) + price(Direction::RIGHT, 'A', pad_number - 1) }
  when [Direction::UP, Direction::DOWN], ['A', Direction::RIGHT]
    memoized(pad_number, 4) { price('A', Direction::DOWN, pad_number - 1) + price(Direction::DOWN, 'A', pad_number - 1) }
  when [Direction::DOWN, Direction::UP], [Direction::RIGHT, 'A']
    memoized(pad_number, 5) { price('A', Direction::UP, pad_number - 1) + price(Direction::UP, 'A', pad_number - 1) }
  when [Direction::UP, Direction::LEFT]
    memoized(pad_number, 6) { price('A', Direction::DOWN, pad_number - 1) + price(Direction::DOWN, Direction::LEFT, pad_number - 1) + price(Direction::LEFT, 'A', pad_number - 1) }
  when [Direction::LEFT, Direction::UP]
    memoized(pad_number, 7) { price('A', Direction::RIGHT, pad_number - 1) + price(Direction::RIGHT, Direction::UP, pad_number - 1) + price(Direction::UP, 'A', pad_number - 1) }
  when ['A', Direction::DOWN]
    memoized(pad_number, 8) do 
      [
        price('A', Direction::DOWN, pad_number - 1) + price(Direction::DOWN, Direction::LEFT, pad_number - 1) + price(Direction::LEFT, 'A', pad_number - 1),
        price('A', Direction::LEFT, pad_number - 1) + price(Direction::LEFT, Direction::DOWN, pad_number - 1) + price(Direction::DOWN, 'A', pad_number - 1)
      ].min
    end
  when [Direction::DOWN, 'A']
    memoized(pad_number, 9) do 
      [
        price('A', Direction::RIGHT, pad_number - 1) + price(Direction::RIGHT, Direction::UP, pad_number - 1) + price(Direction::UP, 'A', pad_number - 1),
        price('A', Direction::UP, pad_number - 1) + price(Direction::UP, Direction::RIGHT, pad_number - 1) + price(Direction::RIGHT, 'A', pad_number - 1)
      ].min
    end
  when [Direction::UP, Direction::RIGHT]
    memoized(pad_number, 10) do 
      [
        price('A', Direction::DOWN, pad_number - 1) + price(Direction::DOWN, Direction::RIGHT, pad_number - 1) + price(Direction::RIGHT, 'A', pad_number - 1),
        price('A', Direction::RIGHT, pad_number - 1) + price(Direction::RIGHT, Direction::DOWN, pad_number - 1) + price(Direction::DOWN, 'A', pad_number - 1)
      ].min
    end
  when [Direction::RIGHT, Direction::UP]
    memoized(pad_number, 11) do 
      [
        price('A', Direction::LEFT, pad_number - 1) + price(Direction::LEFT, Direction::UP, pad_number - 1) + price(Direction::UP, 'A', pad_number - 1),
        price('A', Direction::UP, pad_number - 1) + price(Direction::UP, Direction::LEFT, pad_number - 1) + price(Direction::LEFT, 'A', pad_number - 1)
      ].min
    end
  when ['A', Direction::LEFT]
    memoized(pad_number, 12) do 
      [
        price('A', Direction::DOWN, pad_number - 1) + price(Direction::DOWN, Direction::LEFT, pad_number - 1) + price(Direction::LEFT, Direction::LEFT, pad_number - 1) + price(Direction::LEFT, 'A', pad_number - 1),
        price('A', Direction::LEFT, pad_number - 1) + price(Direction::LEFT, Direction::DOWN, pad_number - 1) + price(Direction::DOWN, Direction::LEFT, pad_number - 1) + price(Direction::LEFT, 'A', pad_number - 1)
      ].min
    end
  when [Direction::LEFT, 'A']
    memoized(pad_number, 13) do 
      [
        price('A', Direction::RIGHT, pad_number - 1) + price(Direction::RIGHT, Direction::RIGHT, pad_number - 1) + price(Direction::RIGHT, Direction::UP, pad_number - 1) + price(Direction::UP, 'A', pad_number - 1),
        price('A', Direction::RIGHT, pad_number - 1) + price(Direction::RIGHT, Direction::UP, pad_number - 1) + price(Direction::UP, Direction::RIGHT, pad_number - 1) + price(Direction::RIGHT, 'A', pad_number - 1)
      ].min
    end
  else
    throw Error.new("Unexpected from: #{from} and to: #{to}") unless from == to
    1
  end
end

def price_code(keypad, code)
  current = 'A'
  paths = ['']
  code.chars.each do |digit|
    new_paths = path(keypad[current], keypad[digit], keypad['panic'])
    paths = paths.flat_map do |path|
      new_paths.map { path + _1 + 'A' }
    end
    current = digit
  end
  paths.map do |path| 
    buttons = path.chars
    (0...buttons.count).reduce(0) do |sum, i|
      from = i.zero? ? 'A' : buttons[i - 1]
      to = buttons[i]
      sum + price(from, to, NUMBER_OF_DIRECTIONAL_PADS)
    end
  end.min * code.to_i
end

puts "Total = #{codes.map{price_code(numeric_pad, _1)}.sum}"