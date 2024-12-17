TEST = false
path = TEST ? 'example_input.txt' : 'input.txt'

output = []

registers, program = File.read(path).split("\n\n")
register_a, register_b, register_c = registers.split("\n").map do |line|
  line.split(': ').last.to_i
end
code_bytes = program.split(': ').last.split(',').map(&:to_i)

a_bits = Array.new(53) { nil }
(0...7).each { a_bits[_1] = 0 }

def check(bits, out, xor)
  out = out ^ xor
  out_bits = [out >> 2 % 2, out >> 1 % 2, out % 2]
  return false if bits[0] == 1 - out_bits[0]
  return false if bits[1] == 1 - out_bits[1]
  return false if bits[2] == 1 - out_bits[2]
  true
end

def create_possibility(template, range, out, xor)
  res = template.dup
  out = out ^ xor
  out_bits = [out >> 2 % 2, out >> 1 % 2, out % 2]
  range.each_with_index { |res_index, out_index| res[res_index] = out_bits[out_index] }
end

COMBINATIONS = [
  { value: 0b000, range: (2..4), xor: 0b011 },
  { value: 0b001, range: (3..5), xor: 0b010 },
  { value: 0b010, range: (0..2), xor: 0b001 },
]

def try(a_bits, step, out)
  possiblilities = []
  offset = step * 3
  first_bits = a_bits[offset...offset + 10]
  possiblilities << create_possibility(a_bits, (2..4), out, 0b011) if check(first_bits[2..4], out, 0b011)
end




# A = CD EFGH IJKL

# B = A % 8   => 0000 0JKL
# B' = B ^ 5 = B ^ 101   => 0000 0!JK!L
# C = A / 2**B => ?     => C = A shift B
# A = A / 8             => A' = A shift 3
# B'' = B' ^ C     =>      => B = B ^ A shift B => A = xxxx 110 xxx{B}
# B''' = B'' ^ 6     => … XXXX X110
# B''' % 8 = 0     => … XXXX X000
# A = 0



# JKL = 0 = 000   =>   B' = 101 = 5   =>   C = EFG   =>   B'' = !EF!G   =>   B''' = E!F!G  =>   E = 0, F = G = 1
# JKL = 1 = 001   =>   B' = 100 = 4   =>   C = FGH   =>   B'' = !FGH    =>   B''' = F!GH   =>   F = H = 0, G = 1
# JKL = 2 = 010   =>   B' = 111 = 7   =>   C = CDE   =>   B'' = !C!D!E  =>   B''' = CD!E   =>   C = D = 0, E = 1
# JKL = 3 = 011   =>   B' = 110 = 6   =>   C = DEF   =>   B'' = !D!EF   =>   B''' = DEF    =>   D = E = F = 0
# JKL = 4 = 100   =>   B' = 001 = 1   =>   C = I10   =>   B'' = I11     =>   B''' = !I01   =>   NON
# JKL = 5 = 101   =>   B' = 000 = 0   =>   C = 101   =>   B'' = 101     =>   B''' = 011    =>   NON
# JKL = 6 = 110   =>   B' = 011 = 3   =>   C = GHI   =>   B'' = G!H!I   =>   B''' = !GH!I  =>   G = I = 1, H = 0
# JKL = 7 = 111   =>   B' = 010 = 2   =>   C = HI1   =>   B'' = !H!I0   =>   B''' = HI0    =>   H = I = 0