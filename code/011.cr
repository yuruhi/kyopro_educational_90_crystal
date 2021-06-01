n = read_line.to_i
dcs = (1..n).map {
  read_line.split.try { |(d, c, s)| {d.to_i, c.to_i, s.to_i64} }
}.sort
day = dcs.max_of { |(d, c, s)| d }

puts dcs.each_with_object([0i64] * day.succ) { |(d, c, s), dp|
  (c..d).reverse_each do |i|
    dp[i] = {dp[i], dp[i - c] + s}.max
  end
  (0...day).each do |i|
    dp[i + 1] = {dp[i + 1], dp[i]}.max
  end
}.max
