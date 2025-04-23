# frozen_string_literal: true

TEST = false
path = TEST ? 'example_input.txt' : 'input.txt'

operations = File.read(path).split("\n").map { |l| l.split(':').flat_map { _1.split(' ') }.map(&:to_i) }

def resolvable?(total, current, values)
  return false if current > total
  return current == total if values.empty?

  resolvable?(total, current + values[0], values[1...values.count]) ||
    resolvable?(total, current * values[0], values[1...values.count]) ||
    resolvable?(total, (current.to_s + values[0].to_s).to_i, values[1...values.count])
end

res = operations.reduce(0) do |sum, operation|
  total = operation[0]
  first = operation[1]
  rest = operation[2...operation.count]
  if resolvable?(total, first, rest)
    sum + total
  else
    sum
  end
end

p res
