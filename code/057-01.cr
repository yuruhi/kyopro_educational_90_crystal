n, m = read_line.split.map(&.to_i)
a = (1..n).map {
  t = read_line.to_i
  b = read_line.split.map(&.to_i.pred)
  b.each_with_object([false] * m) { |i, flag| flag[i] = true }
}
s = read_line.split.map { |x| x == "1" }

(0...m).each do |d|
  if i = a.index { |ai| ai.index(true) == d }
    (0...n).each do |j|
      (0...m).each { |k| a[j][k] ^= a[i][k] } if i != j && a[j][d]
    end
  end
end

count0 = a.count(&.none?)
a.reject!(&.none?).sort_by!(&.index(true).not_nil!)
a.each do |b|
  (0...m).each { |i| s[i] ^= b[i] } if s[b.index(true).not_nil!]
end
puts s.none? ? count0.times.reduce(1i64) { |acc, x| acc * 2 % 998244353 } : 0
