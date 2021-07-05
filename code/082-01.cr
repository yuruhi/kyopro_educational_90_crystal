MOD = 10i64**9 + 7
l, r = read_line.split.map(&.to_i64)
puts (1..19).reduce(0i64) { |sum, d|
  dl = {10i64**d.pred, l}.max
  dr = d < 19 ? {10i64**d - 1, r}.min : r
  if dl <= dr
    val = ((dl + dr) % MOD) * ((dr - dl + 1) % MOD) % MOD * (MOD // 2 + 1)
    (sum + val * d) % MOD
  else
    sum
  end
}
