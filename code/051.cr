n, m, k = read_line.split.try { |(n, m, k)| {n.to_i, m.to_i, k.to_i64} }
a = read_line.split.map(&.to_i64)
b1, b2 = {a[...n // 2], a[n // 2..]}.map { |a|
  (0..m).map do |cnt|
    a.combinations(cnt).map(&.sum).sort
  end
}
puts b1.each_with_index.sum { |c, cnt1|
  c.sum do |sum1|
    (b2[m - cnt1].bsearch_index { |sum2| sum1 + sum2 > k } || b2[m - cnt1].size).to_i64
  end
}
