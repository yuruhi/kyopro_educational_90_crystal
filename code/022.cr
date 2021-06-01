a = read_line.split.map(&.to_i64)
gcd = a.reduce { |x, y| x.gcd y }
puts a.sum { |x| x // gcd - 1 }
