k = read_line.to_i64
divisors = (1..Math.sqrt(k)).select { |x|
  k % x == 0
}.flat_map { |x|
  [x, k // x]
}.uniq.sort

puts divisors.each_with_index.sum { |a, i|
  divisors.skip(i).count { |b|
    k // a % b == 0 && b <= k // a // b
  }
}
