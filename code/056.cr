n, s = read_line.split.map(&.to_i)
ab = Array.new(n) { {Int32, Int32}.from read_line.split.map(&.to_i) }
prev = Array.new(n + 1) { Array(Int32?).new(s + 1, nil) }

ab.each_with_index do |(a, b), i|
  (0..s).each do |j|
    prev[i + 1][j + a] = 0 if (prev[i][j] || i == j == 0) && j + a <= s
    prev[i + 1][j + b] = 1 if (prev[i][j] || i == j == 0) && j + b <= s
  end
end

ans = String::Builder.new
i, j = n, s
while k = prev[i][j]
  ans << 'A' + k
  i -= 1
  j -= ab[i][k]
end
puts i == 0 ? ans.to_s.reverse : "Impossible"
