n, b = read_line.split.map(&.to_i64)
puts (1..11).sum { |size|
  (0..9).to_a.repeated_combinations(size).count { |m_ary|
    m = m_ary.reduce(1i64) { |acc, i| acc * i } + b
    1 <= m <= n && m.to_s.chars.map(&.to_i).sort == m_ary
  }
}
