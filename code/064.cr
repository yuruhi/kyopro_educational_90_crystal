n, q = read_line.split.map(&.to_i)
a = read_line.split.map(&.to_i64)
d = a.each_cons(2).map { |(x, y)| x - y }.to_a
ans = d.sum(&.abs)
q.times do
  l, r, v = read_line.split.map(&.to_i)
  if l != 1
    ans -= d[l - 2].abs
    d[l - 1] -= v
    ans += d[l - 2].abs
  end
  if r != n
    ans -= d[r - 1].abs
    d[r - 1] += v
    ans += d[r - 1].abs
  end
  puts ans
end
