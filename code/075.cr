n = read_line.to_i64
now, cnt = n, 0
(2i64..).each do |x|
  break if x * x > n
  while now % x == 0
    now //= x
    cnt += 1
  end
end
cnt += 1 if now != 1
puts Math.log2(cnt).ceil.to_i
