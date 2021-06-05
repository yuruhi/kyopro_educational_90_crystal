n, p, q = read_line.split.try { |(n, p, q)| {n.to_i, p.to_i64, q.to_i64} }
a = read_line.split.map(&.to_i64)
cnt = 0
(0...n).each do |i1|
  (0...i1).each do |i2|
    x2 = a[i1] * a[i2] % p
    (0...i2).each do |i3|
      x3 = x2 * a[i3] % p
      (0...i3).each do |i4|
        x4 = x3 * a[i4] % p
        (0...i4).each do |i5|
          cnt += 1 if x4 * a[i5] % p == q
        end
      end
    end
  end
end
puts cnt
