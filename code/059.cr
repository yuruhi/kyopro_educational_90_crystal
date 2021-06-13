n, m, q = read_line.split.map(&.to_i)
edges = (1..m).map {
  {Int32, Int32}.from read_line.split.map(&.to_i.pred)
}.sort_by { |x, y| {y, x} }
ab = (1..q).map {
  {Int32, Int32}.from read_line.split.map(&.to_i.pred)
}

ab.each_slice(128) do |ab|
  flag = [UInt128.zero] * n
  ab.each_with_index { |(a, b), i| flag[a] |= 1.to_u128 << i }
  edges.each { |(x, y)| flag[y] |= flag[x] }
  ab.each_with_index { |(a, b), i| puts flag[b].bit(i) == 1 ? "Yes" : "No" }
end
