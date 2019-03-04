reg = /<(?:DAMAGE|damage)[ ](.+)[ ]([\+\-]\d+),[ ](.+),[ ](.+)>/ix

str = "<damage 1d2 +0, force, str>"
regs = reg.inspect
regf = regs[1...regs.rindex('/')]
reg2 = Regexp.new(regf.force_encoding('ASCII-8BIT'), Regexp::FIXEDENCODING | reg.options)

puts reg.inspect
puts reg2.inspect

if reg =~ str
 p [$1, $2, $3, $4, $5]
end
p '----'
if reg2 =~ str
  p [$1, $2, $3, $4, $5]
end

p str.encoding, reg.encoding, reg2.encoding