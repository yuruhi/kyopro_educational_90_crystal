h, w = read_line.split.map(&.to_i)
a = (1..h).map { read_line.split.map(&.to_i) }
puts (1...1 << h).max_of { |bit|
  ind = (0...h).select { |i| bit.bit(i) == 1 }
  ((0...w).select { |j|
    ind.all? { |i| a[i][j] == a[ind[0]][j] }
  }.map { |j| a[ind[0]][j] }.tally.max_of?(&.[1]) || 0) * ind.size
}
