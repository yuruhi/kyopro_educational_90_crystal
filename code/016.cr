n = read_line.to_i
a, b, c = read_line.split.map(&.to_i)

limit = 10000
ans = limit
(0..{limit, n // a}.min).each do |i|
  n2 = n - a * i
  (0..{limit, n2 // b}.min).each do |j|
    n3 = n2 - b * j
    ans = {ans, i + j + n3 // c}.min if n3 % c == 0
  end
end
puts ans
