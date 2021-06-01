n = read_line.to_i
s = read_line

atcoder = "?atcoder"
m = atcoder.size
puts s.chars.each_with_object([1] + [0] * m.pred) { |c, dp|
  if i = atcoder.index(c)
    dp[i] = (dp[i] + dp[i - 1]) % (10**9 + 7)
  end
}.last
