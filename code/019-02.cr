n = read_line.to_i
a = read_line.split.map(&.to_i)
puts Hash({Int32, Int32}, Int32).new { |hash, (l, r)|
  hash[{l, r}] = l == r ? 0 : {
    (l + 2).step(to: r - 2, by: 2).min_of? { |mid|
      hash[{l, mid}] + hash[{mid, r}]
    } || 10**9,
    hash[{l + 1, r - 1}] + (a[l] - a[r - 1]).abs,
  }.min
}[{0, 2 * n}]
