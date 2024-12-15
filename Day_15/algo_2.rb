require 'colorize'

TEST = false
path = TEST ? 'example_input.txt' : 'input.txt'

module Direction
  UP = '^'
  LEFT = '<'
  DOWN = 'v'
  RIGHT = '>'
end

class Place
  module Type
    EMPTY = '.'
    WALL = '#'
    CRATE = 'O'
    CRATE_LEFT = '['
    CRATE_RIGHT = ']'
    ROBOT = '@'
  end


  attr_accessor :type

  @@map = nil
  @@robot = nil

  def self.map=(map)
    @@map = map
  end

  def self.map
    @@map
  end

  def self.print_map
    @@map.each do |line|
      puts line.join
    end
  end

  def initialize(char, x, y)
    @type =
      case char
      when Type::CRATE
        x.even? ? Type::CRATE_LEFT : Type::CRATE_RIGHT
      when Type::ROBOT
        x.even? ? Type::ROBOT : Type::EMPTY
      else
        char
      end
    @x = x
    @y = y
    @@robot = self if @type == Type::ROBOT
  end

  def to_s
    case @type
    when Type::ROBOT
      @type.red
    when Type::CRATE_LEFT, Type::CRATE_RIGHT
      @type.yellow
    else
      @type
    end
  end

  def self.move_robot(direction)
    @@robot.push!(Type::EMPTY, direction) if @@robot.pushable?(direction)
  end

  def neighbour(direction)
    case direction
    when Direction::UP
      @@map[@y - 1][@x]
    when Direction::LEFT
      @@map[@y][@x - 1]
    when Direction::DOWN
      @@map[@y  + 1][@x]
    when Direction::RIGHT
      @@map[@y][@x + 1]
    end
  end

  def pushable?(direction, check_other_half: true)
    check_other_half &= [Direction::UP, Direction::DOWN].include?(direction)
    case [@type, check_other_half]
    in Type::WALL, _
      false
    in Type::EMPTY, _
      true
    in Type::CRATE_LEFT, true
      neighbour(Direction::RIGHT).pushable?(direction, check_other_half: false) && pushable?(direction, check_other_half: false)
    in Type::CRATE_RIGHT, true
      neighbour(Direction::LEFT).pushable?(direction, check_other_half: false) && pushable?(direction, check_other_half: false)
    else
      neighbour(direction).pushable?(direction)
    end
  end

  def push!(other_type, direction, check_other_half: true)
    check_other_half &= [Direction::UP, Direction::DOWN].include?(direction) && [Type::CRATE_LEFT, Type::CRATE_RIGHT].include?(@type)
    if check_other_half
      other = @type == Type::CRATE_LEFT ? neighbour(Direction::RIGHT) : neighbour(Direction::LEFT)
      self.push!(other_type, direction, check_other_half: false)
      other.push!(Type::EMPTY, direction, check_other_half: false)
      return
    elsif @type != Type::EMPTY
      neighbour(direction).push!(@type, direction)
    end
    @type = other_type
    @@robot = self if @type == Type::ROBOT
  end

  def gps_coordinates
    return 0 unless @type == Type::CRATE_LEFT
    100 * @y + @x
  end

  def self.map_gps_value
    @@map.sum do |line|
      line.sum(&:gps_coordinates)
    end
  end
end

map_input, moves = File.read(path).split("\n\n")
map_input = map_input.split("\n").map(&:chars)

Place.map = Array.new(map_input.count) { Array.new(map_input.first.count * 2) }

map_input.each_with_index do |line, y|
  line.each_with_index do |c, x|
    Place.map[y][2 * x] = Place.new(c, 2 * x, y)
    Place.map[y][2 * x + 1] = Place.new(c, 2 * x + 1, y)
  end
end

p 'Initial state:'
Place.print_map
moves.split("\n").flat_map(&:chars).each do |dir|
  Place.move_robot(dir)
end

p 'Final state:'
Place.print_map

p "Sum of all boxes' GPS coordinates: #{Place.map_gps_value}"
