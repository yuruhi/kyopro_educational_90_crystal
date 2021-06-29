n, m = read_line.split.map(&.to_i)
cnt = [0] * n
m.times do
  a, b = read_line.split.map(&.to_i.pred)
  cnt[{a, b}.max] += 1
end
puts cnt.count(1)
