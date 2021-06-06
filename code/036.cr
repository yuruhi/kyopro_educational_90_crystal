n, q = read_line.split.map(&.to_i)
x, y = (1..n).map {
  a, b = read_line.split.map(&.to_i64)
  {a - b, a + b}
}.transpose
xy = x.minmax + y.minmax

q.times do
  i = read_line.to_i - 1
  puts [x[i], x[i], y[i], y[i]].zip(xy).max_of { |a, b| (a - b).abs }
end
