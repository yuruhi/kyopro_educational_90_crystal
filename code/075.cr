struct Int
  def prime_factors
    factors = [] of self
    n = self
    (self.class.new(2)..).each do |x|
      break if x * x > self
      while n % x == 0
        n //= x
        factors << x
      end
    end
    factors << n if n != 1
    factors
  end
end

n = read_line.to_i64
cnt = n.prime_factors.size
puts Math.log2(cnt).ceil.to_i
