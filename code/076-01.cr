n = read_line.to_i
a = read_line.split.map(&.to_i64) * 2
sum = a.sum // 2

culsum = a.each_with_object([0i64]) do |x, culsum|
  culsum << culsum[-1] + x
end

puts (0...n).any? { |i|
  pos = (i...2*n).bsearch { |j| (culsum[j] - culsum[i]) * 10 >= sum }
	pos && (culsum[pos] - culsum[i]) * 10 == sum
} ? "Yes" : "No"
