require "big"
n, m = read_line.split.map(&.to_i)
a = (1..n).map {
  read_line
  b = read_line.split.map(&.to_i.pred)
  b.reduce(BigInt.zero) { |acc, i| acc | BigInt.new(1) << i }
}
s = read_line.delete(' ').reverse.to_big_i(2)

basis = [] of BigInt
a.each do |e|
  basis.each { |b| e = {e, e ^ b}.min }
  basis << e unless e.zero?
end
basis.sort.reverse_each do |b|
  i = (0...m).reverse_each.find { |i| b.bit(i) == 1 }.not_nil!
  s ^= b if s.bit(i) == 1
end
puts s.zero? ? (n - basis.size).times.reduce(1i64) { |acc, _| acc * 2 % 998244353 } : 0
