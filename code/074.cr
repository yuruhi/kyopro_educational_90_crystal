n = read_line.to_i
s = read_line.chars
puts s.each_with_index.sum { |c, i|
  2i64**i * (c - 'a')
}
