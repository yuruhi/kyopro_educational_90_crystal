n = read_line.to_i
ranges = (1..n).map {
  l, r = read_line.split.map(&.to_i)
  l..r
}
puts ranges.each_combination(2).sum { |(r1, r2)|
  r2.sum { |x| (r1.end - x).clamp(0, r1.size) } / r1.size / r2.size
}
