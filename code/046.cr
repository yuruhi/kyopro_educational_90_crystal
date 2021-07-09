read_line
a = (1..3).map {
  b = read_line.split.map(&.to_i.%(46))
  (0...46).map { |i| b.count(i) }
}
mod46 = (0...46).to_a
puts Array.product(mod46, mod46, mod46).select { |indices|
  indices.sum % 46 == 0
}.sum { |indices|
  a.zip(indices).product { |(b, i)| b[i].to_i64 }
}
