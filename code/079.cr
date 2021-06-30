h, w = read_line.split.map(&.to_i)
a = (1..h).map { read_line.split.map(&.to_i64) }
b = (1..h).map { read_line.split.map(&.to_i64) }
cnt = (0...h - 1).sum { |i|
  (0...w - 1).sum { |j|
    x = b[i][j] - a[i][j]
    [i, i + 1].product([j, j + 1]) { |i2, j2|
      a[i2][j2] += x
    }
    x.abs
  }
}
if a == b
  puts "Yes", cnt
else
  puts "No"
end
