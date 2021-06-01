n = read_line.to_i
sums = {0, 1}.map { [0] * n.succ }
n.times do |i|
  c, p = read_line.split.map(&.to_i)
  sums.each { |sum| sum[i + 1] += sum[i] }
  sums[c - 1][i + 1] += p
end
read_line.to_i.times do
  l, r = read_line.split.map(&.to_i)
  puts sums.join(' ') { |sum| sum[r] - sum[l - 1] }
end
