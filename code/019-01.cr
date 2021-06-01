def rec(a, memo, l, r) : Int32
  memo[l][r] ||=
    if l == r
      0
    else
      {
        (l + 2).step(to: r - 2, by: 2).min_of? { |mid|
          rec(a, memo, l, mid) + rec(a, memo, mid, r)
        } || 10**9,
        rec(a, memo, l + 1, r - 1) + (a[l] - a[r - 1]).abs,
      }.min
    end
end

n = read_line.to_i
a = read_line.split.map(&.to_i)
memo = Array.new(2 * n) { Array(Int32?).new(2 * n + 1, nil) }
puts rec(a, memo, 0, 2 * n)
