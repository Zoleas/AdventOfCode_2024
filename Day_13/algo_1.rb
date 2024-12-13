TEST = false
path = TEST ? 'example_input.txt' : 'input.txt'

machines = File.read(path).split("\n\n").map do |machine|
  button_a, button_b, prize = machine.split("\n")
  button_a = button_a[12...button_a.length].split(', Y+').map(&:to_i)
  button_b = button_b[12...button_b.length].split(', Y+').map(&:to_i)
  prize = prize[9...prize.length].split(', Y=').map(&:to_i)
  [button_a, button_b, prize]
end

res = machines.reduce(0) do |sum, machine|
  target_x = machine.last[0]
  target_y = machine.last[1]
  button_a = machine[0]
  button_b = machine[1]
  possible_values = (0..100).filter_map do |a|
    a_x = a * button_a[0]
    next nil if a_x > target_x
    b, b_rest = (target_x - a_x).divmod(button_b[0])
    next nil unless b_rest.zero?
    next nil unless a * button_a[1] + b * button_b[1] == target_y
    [a, b]
  end
  possible_values.empty? ? sum : sum + possible_values.map { |a, b| 3 * a + b }.min
end

p res
