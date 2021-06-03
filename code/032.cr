n = read_line.to_i
a = (1..n).map { read_line.split.map(&.to_i) }
m = read_line.to_i
flag = (1..n).map { [true] * n }
m.times do
  x, y = read_line.split.map(&.to_i.pred)
  flag[x][y] = flag[y][x] = false
end

puts (0...n).to_a.each_permutation.select { |perm|
  perm.each_cons(2).all? { |(i, j)| flag[i][j] }
}.min_of? { |perm|
  (0...n).sum { |i| a[perm[i]][i] }
} || -1
