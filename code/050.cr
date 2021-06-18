MOD = 10**9 + 7
n, l = read_line.split.map(&.to_i)
dp = Array.new(n + 1, 0i64)
dp[0] = 1i64
(1..n).each do |i|
  dp[i] += dp[i - 1]
  dp[i] += dp[i - l] if i - l >= 0
  dp[i] %= MOD
end
puts dp[n]
