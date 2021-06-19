n = read_line.to_i
puts (1..n).map {
  read_line.split.map(&.to_i64)
}.transpose.sum { |a|
  x = a.sort[n // 2]
  a.sum { |y| (x - y).abs }
}
