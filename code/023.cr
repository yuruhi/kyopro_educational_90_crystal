MOD = 10**9 + 7
h, w = read_line.split.map(&.to_i)
grid = (1..h).map { read_line }

a = (1..w).reduce([[0], [1], [] of Int32, [] of Int32]) { |(a00, a01, a10, a11), i|
  b00 = (a00 + a01).map { |x| x << 1 }
  b01 = a00.map { |x| x << 1 | 1 }
  b10 = (a10 + a11).map { |x| x << 1 }
  b11 = (a01 + a10).map { |x| x << 1 | 1 }
  [b00, b01, b10, b11]
}.flatten
m = a.size

hash = a.zip(0..).to_h
next1 = a.map { |bit| hash[bit >> 1] }
next2 = a.map { |bit| hash[bit >> 1 | 1 << w]? }

dp = [1] + [0] * m.pred
(0...h).each do |i|
  (0...w).each do |j|
    dp = (0...m).each_with_object([0] * m) do |k, dp2|
      next if dp[k] == 0
      bit = a[k]
      dp2[n1 = next1[k]] = (dp2[n1] + dp[k]) % MOD
      unless grid[i][j] == '#' ||
             (i != 0 && j != 0 && bit.bit(0) == 1) ||
             (i != 0 && bit.bit(1) == 1) ||
             (i != 0 && j != w - 1 && bit.bit(2) == 1) ||
             (j != 0 && bit.bit(w) == 1)
        dp2[n2 = next2[k].not_nil!] = (dp2[n2] + dp[k]) % MOD
      end
    end
  end
end
puts dp.reduce(0) { |sum, x| (sum + x) % MOD }
