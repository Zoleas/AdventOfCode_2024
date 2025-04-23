# frozen_string_literal: true

TEST = false
path = TEST ? 'example_input.txt' : 'input.txt'

output = []

registers, program = File.read(path).split("\n\n")
register_a, register_b, register_c = registers.split("\n").map do |line|
  line.split(': ').last.to_i
end
code_bytes = program.split(': ').last.split(',').map(&:to_i)

module OpCode
  ADV = 0
  BXL = 1
  BST = 2
  JNZ = 3
  BXC = 4
  OUT = 5
  BDV = 6
  CDV = 7
end

instruction_pointer = 0

while instruction_pointer + 1 < code_bytes.count
  jumped = false
  opcode = code_bytes[instruction_pointer]
  literal_operand = code_bytes[instruction_pointer + 1]
  combo_operand =
    case literal_operand
    when (0..3)
      literal_operand
    when 4
      register_a
    when 5
      register_b
    when 6
      register_c
    end

  case opcode
  when 0
    register_a /= 2**combo_operand
  when 1
    register_b ^= literal_operand
  when 2
    register_b = combo_operand % 8
  when 3
    unless register_a.zero?
      instruction_pointer = literal_operand
      jumped = true
    end
  when 4
    register_b ^= register_c
  when 5
    output << (combo_operand % 8).to_s
  when 6
    register_b = register_a / 2**combo_operand
  when 7
    register_c = register_a / 2**combo_operand
  end
  instruction_pointer += 2 unless jumped
end

p "Output: #{output.join(',')}"
