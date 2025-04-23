# frozen_string_literal: true

TEST = true
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
    @type = char
    @x = x
    @y = y
    @@robot = self if @type == Type::ROBOT
  end

  def to_s
    @type
  end

  def self.move_robot(direction)
    @@robot.pushed_by?(Type::EMPTY, direction)
  end

  def neighbour(direction)
    case direction
    when Direction::UP
      @@map[@y - 1][@x]
    when Direction::LEFT
      @@map[@y][@x - 1]
    when Direction::DOWN
      @@map[@y + 1][@x]
    when Direction::RIGHT
      @@map[@y][@x + 1]
    end
  end

  def pushed_by?(other_type, direction)
    pushed =
      case @type
      when Type::WALL
        false
      when Type::EMPTY
        true
      else
        neighbour(direction).pushed_by?(@type, direction)
      end
    if pushed
      @type = other_type
      @@robot = self if @type == Type::ROBOT
    end
    pushed
  end

  def gps_coordinates
    return 0 unless @type == Type::CRATE

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

Place.map = Array.new(map_input.count) { Array.new(map_input.first.count) }

map_input.each_with_index do |line, y|
  line.each_with_index do |c, x|
    Place.map[y][x] = Place.new(c, x, y)
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
