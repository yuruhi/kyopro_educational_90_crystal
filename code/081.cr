n, k = read_line.split.map(&.to_i)
ab = Array.new(n) {
  {Int32, Int32}.from read_line.split.map(&.to_i)
}

h = {ab.max_of(&.[0]), k}.max + 1
w = {ab.max_of(&.[1]), k}.max + 1
sum = Array.new(h + 1) { Array.new(w + 1, 0) }
ab.each do |a, b|
  sum[a + 1][b + 1] += 1
end
(1..h).each do |i|
  (1..w).each do |j|
    sum[i][j] += sum[i - 1][j]
  end
end
(1..h).each do |i|
  (1..w).each do |j|
    sum[i][j] += sum[i][j - 1]
  end
end

puts (0...h - k).max_of { |i|
  (0...w - k).max_of { |j|
    sum[i][j] - sum[i][j + k + 1] - sum[i + k + 1][j] + sum[i + k + 1][j + k + 1]
  }
}
