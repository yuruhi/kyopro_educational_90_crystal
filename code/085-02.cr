k = read_line.to_i64
puts (1..Math.cbrt(k)).sum { |a|
  (a..Math.sqrt(k / a)).count { |b|
    k % a == 0 && k // a % b == 0
  }
}
