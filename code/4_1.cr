h, w = read_line.split.map(&.to_i)
a = (1..h).map { read_line.split.map(&.to_i) }
row_sum = a.map(&.sum)
column_sum = a.transpose.map(&.sum)
(0...h).each do |i|
  puts (0...w).join(' ') { |j|
    row_sum[i] + column_sum[j] - a[i][j]
  }
end
