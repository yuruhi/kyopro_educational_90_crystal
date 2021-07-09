k = read_line.to_i
puts k % 9 == 0 ? k.times.each_with_object([1i64]) { |_, dp|
  dp << dp.reverse_each.first(9).sum % (10**9 + 7)
}.last : 0
