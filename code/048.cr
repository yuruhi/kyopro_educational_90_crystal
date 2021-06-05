n, k = read_line.split.map(&.to_i)
puts (1..n).flat_map {
  a, b = read_line.split.map(&.to_i64)
  [a - b, b]
}.sort[-k..].sum
