# frozen_string_literal: true

TEST = false
path = TEST ? 'example_input.txt' : 'input.txt'

registers, program = File.read(path).split("\n\n")
registers.split("\n").map do |line|
  line.split(': ').last.to_i
end
code_bytes = program.split(': ').last.split(',').map(&:to_i)

a_bits = Array.new(7 + 3 * code_bytes.count) { nil }
(0...7).each { a_bits[_1] = 0 }

def check(bits, out, xor)
  out ^= xor
  out_bits = [out >> 2 % 2, out >> 1 % 2, out % 2]
  return false if bits[0] == 1 - out_bits[0]
  return false if bits[1] == 1 - out_bits[1]
  return false if bits[2] == 1 - out_bits[2]

  true
end

def try(b, bits, step, out)
  # p "Trying b: #{b}"
  b_1 = b ^ 5
  offset = step * 3
  c_range_end = 10 - b_1 + offset
  c_range = ((c_range_end - 3)...c_range_end)
  possible_c = bits[c_range]
  c = out ^ 6 ^ b ^ 5
  c_bits = [(c >> 2) % 2, (c >> 1) % 2, c % 2]
  return nil if possible_c[0] == 1 - c_bits[0]
  return nil if possible_c[1] == 1 - c_bits[1]
  return nil if possible_c[2] == 1 - c_bits[2]

  res = bits.dup
  c_range.each_with_index { |res_index, c_index| res[res_index] = c_bits[c_index] }
  b_bits = [(b >> 2) % 2, (b >> 1) % 2, b % 2]
  b_range = ((offset + 7)...(offset + 10))
  possible_b = res[b_range]
  return nil if possible_b[0] == 1 - b_bits[0]
  return nil if possible_b[1] == 1 - b_bits[1]
  return nil if possible_b[2] == 1 - b_bits[2]

  b_range.each_with_index { |res_index, b_index| res[res_index] = b_bits[b_index] }
  # p "Works by putting #{c_bits} to indexes #{c_range.to_a} and #{b_bits} to indexes #{b_range.to_a}"
  res
end

def process(a_bits, code_bytes)
  possiblilities = [a_bits]
  (0...code_bytes.count).each do |step|
    # p "Step: #{step + 1}, int to print #{code_bytes[code_bytes.count - step - 1]}"
    possiblilities =
      possiblilities.map do |p|
        # p "For bits starting with #{p.compact}"
        (0..7).each_with_object([]) do |b, res|
          res << try(b, p, step, code_bytes[code_bytes.count - step - 1])
        end
      end.flatten(1).compact
  end
  possiblilities
end

possiblilities = process(a_bits, code_bytes)

res_bit_string = possiblilities.min.map(&:to_s).join
p "Final number #{res_bit_string.to_i(2)}"
