def lis(a)
  dp = [] of Int32
  a.map do |x|
    if pos = dp.bsearch_index { |y| y >= x }
      dp[pos] = x
      pos + 1
    else
      dp << x
      dp.size
    end
  end
end

n = read_line.to_i
a = read_line.split.map(&.to_i)
lis1, lis2 = lis(a), lis(a.reverse).reverse
puts lis1.zip(lis2).max_of { |x, y| x + y - 1 }
