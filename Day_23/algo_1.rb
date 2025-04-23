# frozen_string_literal: true

TEST = false
path = TEST ? 'example_input.txt' : 'input.txt'

connections = File.read(path).split("\n").map { _1.split('-') }

class Computer
  attr_accessor :name, :connected_computers

  def initialize(name)
    @name = name
    @connected_computers = Set.new
  end

  def ==(other)
    other.is_a? Computer and @name == other.name
  end

  def eql?(other)
    other.is_a? Computer and @name.eql? other.name
  end

  def hash
    @name.hash
  end

  def connect_to(computer)
    @connected_computers << computer
  end

  def to_s
    "Computer #{@name}; connected to #{@connected_computers.map(&:name).join(', ')}."
  end

  def may_be_chief?
    @name[0] == 't'
  end

  def self.connect(comp1, comp2)
    comp1.connect_to(comp2)
    comp2.connect_to(comp1)
  end
end

def build(connections)
  computers = {}
  connections.each do |connection|
    name1 = connection[0]
    comp1 = computers[name1] || Computer.new(name1)
    computers[name1] = comp1
    name2 = connection[1]
    comp2 = computers[name2] || Computer.new(name2)
    computers[name2] = comp2
    Computer.connect(comp1, comp2)
  end
  computers.values
end

def sets_of_three(computers)
  sets = Set.new
  computers.each do |computer|
    computer.connected_computers.each do |comp2|
      comp2.connected_computers.each do |comp3|
        sets << Set[computer, comp2, comp3] if comp3.connected_computers.include?(computer)
      end
    end
  end
  sets.filter { |set| set.any?(&:may_be_chief?) }
end

computers = build(connections)
sets = sets_of_three(computers)
p sets.count
