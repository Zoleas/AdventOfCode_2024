TEST = false
path = TEST ? 'example_input.txt' : 'input.txt'


connections = File.read(path).split("\n").map { _1.split('-') }

class Computer
  attr_accessor :name
  attr_accessor :connected_computers

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

  def connected_groups(res_set, verified = Set[], unverified = connected_computers + Set[self])
    new_verified = verified + Set[self]
    new_unverified = unverified & connected_computers
    if new_unverified.empty?
      res_set << new_verified
      return
    end
    new_unverified.each { |comp| comp.connected_groups(res_set, new_verified, new_unverified) }
  end

  def self.connect(comp1, comp2)
    comp1.connect_to(comp2)   
    comp2.connect_to(comp1)   
  end

  def self.password_by_building_sets(sets, computers)
    puts "#{sets.count} sets of #{sets.first.count}"
    return sets.first.map(&:name).sort.join(',') if sets.count == 1
    return 'FUCK' if sets.empty?
    bigger_sets = Set[]
    sets.each do |set|
      computers.each do |computer|
        bigger_sets << set + Set[computer] if set.subset?(computer.connected_computers)
      end
    end
    password_by_building_sets(bigger_sets, computers)
  end
end

def build(connections)
  computers = Hash.new
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
  sets
end

computers = build(connections)

sets = sets_of_three(computers)

p "Password: #{Computer.password_by_building_sets(sets, computers)}"
