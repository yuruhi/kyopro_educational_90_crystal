n = read_line.to_i64
s = read_line
puts n * n.pred // 2 - s.chars.chunk(&.itself).sum { |chunk|
  cnt = chunk[1].size.to_i64
  cnt * cnt.pred // 2
}
