MOD = 10**5
n, k = read_line.split.try { |(n, k)| {n.to_i, k.to_i64} }

next_num = (0...MOD).map do |x|
  # 0.36.0 からは (x + x.digits.sum) % MOD とかける
  (x + x.to_s.chars.sum(&.to_i)) % MOD
end

time = Array(Int32?).new(MOD, nil)
cnt = 0
while time[n].nil?
  time[n] = cnt
  n = next_num[n]
  cnt += 1
end

to_cycle = time[n].not_nil!
cycle = cnt - to_cycle
k = (k - to_cycle) % cycle + to_cycle if k >= to_cycle
puts time.index(k)
