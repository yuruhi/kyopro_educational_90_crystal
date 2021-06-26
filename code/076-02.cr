n = read_line.to_i
a = read_line.split.map(&.to_i64)
sum = (a * 2).each_with_object([0i64]) { |x, sum| sum << sum[-1] + x }
r = 0
puts (0...n).any? { |l|
  while (sum[r + 1] - sum[l]) * 10 <= sum[n]
    r += 1
  end
  (sum[r] - sum[l]) * 10 == sum[n]
} ? "Yes" : "No"
