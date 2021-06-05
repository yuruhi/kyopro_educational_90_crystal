puts (1..read_line.to_i).reduce(1i64) { |acc, i|
  acc * read_line.split.sum(&.to_i) % (10**9 + 7)
}
