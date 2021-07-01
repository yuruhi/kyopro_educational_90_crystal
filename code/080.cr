n, d = read_line.split.map(&.to_i)
a = read_line.split.map(&.to_i64)
puts (0...1 << n).sum { |bit|
  x = a.each_with_index.reduce(0i64) { |acc, (x, i)|
    bit.bit(i) == 1 ? acc | x : acc
  }.popcount
  y = 1i64 << (d - x)
  bit.popcount.even? ? y : -y
}
