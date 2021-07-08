MOD = 1000000007i64
n, q = read_line.split.map(&.to_i)
xyzw = Array.new(q) {
  x, y, z, w = read_line.split
  {x, y, z}.map(&.to_i.pred) + {w.to_i64}
}
puts (0...60).reduce(1i64) { |acc, b|
  acc * (0...1 << n).count { |bit|
    xyzw.all? { |x, y, z, w|
      bit.bit(x) | bit.bit(y) | bit.bit(z) == w.bit(b)
    }
  } % MOD
}
