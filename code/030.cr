n, k = read_line.split.map(&.to_i)
cnt = [0] * n.succ
(2..n).each do |x|
  next if cnt[x] != 0
  x.step(to: n, by: x) { |y|
    cnt[y] += 1
  }
end
puts cnt.count { |x| x >= k }
