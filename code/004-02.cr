h, w = read_line.split.map(&.to_i)
a = (1..h).map { read_line.split.map(&.to_i) }
row_sum = a.map(&.sum)
column_sum = a.transpose.map(&.sum)

# Enumerable#join(separator, io : IO) は今のバージョンでは非推奨
(0...h).join('\n', STDOUT) do |i, io|
  (0...w).join(' ', io) { |j, io|
    io << row_sum[i] + column_sum[j] - a[i][j]
  }
end
