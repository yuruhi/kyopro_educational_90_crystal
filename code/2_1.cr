n = read_line.to_i
puts ['(', ')'].repeated_permutations(n).select { |s|
  a = s.reduce([0]) { |acc, c|
    acc << acc[-1] + (c == '(' ? 1 : -1)
  }
  a[-1] == 0 && a.all? { |i| i >= 0 }
}.join('\n', &.join)
