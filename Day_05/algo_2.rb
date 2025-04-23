# frozen_string_literal: true

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
  true
end

def correct!(rules, print)
  (0...print.count).each do |i|
    ((i + 1)...print.count).each do |j|
      print[i], print[j] = print[j], print[i] if rules.include?([print[j], print[i]])
    end
  end
end

corrected_prints = prints.reject { correct?(rules, _1) }.each { correct!(rules, _1) }

res = corrected_prints.sum { _1[(_1.count - 1) / 2] }
p res
