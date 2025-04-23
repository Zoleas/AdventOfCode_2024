# frozen_string_literal: true

TEST = false
path = TEST ? 'example_input.txt' : 'input.txt'

def is_safe(report)
  differences = (1...report.size).map do |i|
    report[i] - report[i - 1]
  end
  return false unless differences.all?(&:positive?) || differences.all?(&:negative?)
  return false unless differences.all? { |d| d.abs <= 3 }

  true
end

def is_dampened_safe(report)
  return true if is_safe(report)

  (0...report.size).each do |i|
    return true if is_safe(report[0...i] + report[(i + 1)...report.count])
  end
  false
end

reports = File.read(path).split("\n").map { |line| line.split(' ').map(&:to_i) }
res = reports.select do |report|
  is_dampened_safe(report)
end.count
p res
