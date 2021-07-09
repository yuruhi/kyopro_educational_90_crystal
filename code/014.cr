read_line
a = read_line.split.map(&.to_i64).sort
b = read_line.split.map(&.to_i64).sort
puts a.zip(b).sum { |i, j| (i - j).abs }
