struct Int
  def pow(exp : Int, mod : Int)
    t, result = self, typeof(self).new(1)
    while exp > 0
      result = result * t % MOD if exp.odd?
      t = t * t % MOD
      exp >>= 1
    end
    result
  end
end

MOD = 10**9 + 7
n, k = read_line.split.map(&.to_i64)
ans = k
if n >= 2
  ans = ans * (k - 1) % MOD
  ans = ans * (k - 2).pow(n - 2, MOD) % MOD
end
puts ans
