n = read_line.to_i
lr = (1..n).map { read_line.split.map(&.to_i) }
puts lr.each_combination(2).sum { |(lr1, lr2)|
  l1, r1 = lr1
  l2, r2 = lr2
  (l2..r2).sum { |x|
    (r1 - x).clamp(0, r1 - l1 + 1)
  } / (r2 - l2 + 1) / (r1 - l1 + 1)
}
