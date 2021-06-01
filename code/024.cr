n, k = read_line.split.map(&.to_i)
a = read_line.split.map(&.to_i)
b = read_line.split.map(&.to_i)
x = k - a.zip(b).sum { |i, j| (i - j).abs }
puts x >= 0 && x.even? ? "Yes" : "No"
