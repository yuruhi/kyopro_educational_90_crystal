a, b = read_line.split.map(&.to_i)
if a == 1 || b == 1
  puts a * b
else
  puts (a.succ // 2) * (b.succ // 2)
end
