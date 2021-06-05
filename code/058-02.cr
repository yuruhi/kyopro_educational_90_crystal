M   = 60
MOD = 10**5
n, k = read_line.split.try { |(n, k)| {n.to_i, k.to_i64} }
next_num = Array.new(M) { Array.new(MOD, -1) }
next_num[0] = (0...MOD).map do |x|
  # 0.36.0 からは (x + x.digits.sum) % MOD とかける
  (x + x.to_s.chars.sum(&.to_i)) % MOD
end
(1...M).each do |i|
  (0...MOD).each do |j|
    next_num[i][j] = next_num[i - 1][next_num[i - 1][j]]
  end
end
(0...M).each do |i|
  n = next_num[i][n] if k.bit(i) == 1
end
puts n
