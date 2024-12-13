TEST = false
path = TEST ? 'example_input.txt' : 'input.txt'

rules, prints = File.read(path).split("\n\n").map { _1.split("\n") }
rules = rules.map { _1.split('|').map(&:to_i) }
prints = prints.map { _1.split(',').map(&:to_i) }

def correct?(rules, print)
  (0...print.count).each do |i|
    ((i + 1)...print.count).each do |j|
      return false if rules.include?([print[j], print[i]])
    end
  end
  return true
end

correct_prints = prints.select { |print| correct?(rules, print) }

res = correct_prints.sum { _1[(_1.count - 1) / 2] }
p res
