# frozen_string_literal: true

TEST = false
path = TEST ? 'example_input.txt' : 'input.txt'

machines = File.read(path).split("\n\n").map do |machine|
  button_a, button_b, prize = machine.split("\n")
  button_a = button_a[12...button_a.length].split(', Y+').map(&:to_i)
  button_b = button_b[12...button_b.length].split(', Y+').map(&:to_i)
  prize = prize[9...prize.length].split(', Y=').map { _1.to_i + 10_000_000_000_000 }
  [button_a, button_b, prize]
end

res = machines.reduce(0) do |sum, machine|
  target_x = machine.last[0]
  target_y = machine.last[1]
  button_a = machine[0]
  button_b = machine[1]
  denom = button_b[1] * button_a[0] - button_b[0] * button_a[1]
  next sum if denom.zero?

  b, rest_b = (target_y * button_a[0] - target_x * button_a[1]).divmod(denom)
  next sum unless rest_b.zero?

  a, rest_a = (target_x - b * button_b[0]).divmod(button_a[0])
  next sum unless rest_a.zero?

  sum + 3 * a + b
end

p res
