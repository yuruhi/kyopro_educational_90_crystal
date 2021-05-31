n = read_line.to_i
['(', ')'].each_repeated_permutation(n, true) { |s|
  a = s.reduce([0]) { |acc, c|
    acc << acc[-1] + (c == '(' ? 1 : -1)
  }
  if a[-1] == 0 && a.all? { |i| i >= 0 }
    puts s.join
  end
}
