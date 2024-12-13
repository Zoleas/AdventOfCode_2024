TEST = false
path = TEST ? 'example_input.txt' : 'input.txt'

reports = File.read(path).split("\n").map { |line| line.split(' ').map(&:to_i) }
res = reports.select do |report|
  differences = (1...report.size).map do |i|
    report[i] - report[i - 1]
  end
  next false unless differences.all?(&:positive?) || differences.all?(&:negative?)
  next false unless differences.all? { |d| d.abs <= 3 }
  true
end.count
p res
