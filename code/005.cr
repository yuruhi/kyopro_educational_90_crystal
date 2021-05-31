struct Mint
  MOD = 1000000007i64

  def self.zero
    new
  end

  def self.raw(value : Int64)
    result = new
    result.value = value
    result
  end

  @value : Int64

  def initialize
    @value = 0i64
  end

  def initialize(value)
    @value = value.to_i64 % MOD
  end

  def initialize(m : self)
    @value = m.value
  end

  protected def value=(value : Int64)
    @value = value
  end

  getter value : Int64

  def + : self
    self
  end

  def - : self
    Mint.raw(value != 0 ? MOD &- value : 0i64)
  end

  def +(v)
    self + v.to_m
  end

  def +(m : self)
    x = value &+ m.value
    x &-= MOD if x >= MOD
    Mint.raw(x)
  end

  def -(v)
    self - v.to_m
  end

  def -(m : self)
    x = value &- m.value
    x &+= MOD if x < 0
    Mint.raw(x)
  end

  def *(v)
    self * v.to_m
  end

  def *(m : self)
    Mint.new(value &* m.value)
  end

  def /(v)
    self / v.to_m
  end

  def /(m : self)
    raise DivisionByZeroError.new if m.value == 0
    a, b, u, v = m.to_i64, MOD, 1i64, 0i64
    while b != 0
      t = a // b
      a &-= t &* b
      a, b = b, a
      u &-= t &* v
      u, v = v, u
    end
    Mint.new(value &* u)
  end

  def //(v)
    self / v
  end

  def **(exponent : Int)
    t, res = self, Mint.raw(1i64)
    while exponent > 0
      res *= t if exponent & 1 == 1
      t *= t
      exponent >>= 1
    end
    res
  end

  def ==(m : self)
    value == m.value
  end

  def ==(m : Int)
    raise NotImplementedError.new("==")
  end

  def succ
    Mint.raw(value != MOD &- 1 ? value &+ 1 : 0i64)
  end

  def pred
    Mint.raw(value != 0 ? value &- 1 : MOD &- 1)
  end

  def abs
    self
  end

  def to_i64 : Int64
    value
  end

  delegate to_s, to: @value
  delegate inspect, to: @value
end

struct Int
  {% for op in %w[+ - * / //] %}
      def {{op.id}}(value : Mint)
        to_m {{op.id}} value
      end
  {% end %}

  def to_m : Mint
    Mint.new(self)
  end
end

class String
  def to_m : Mint
    Mint.new(self)
  end
end

struct Int
  def powmod(exp : T, mod : self) forall T
    n = self % mod
    res = typeof(self).new(1)
    while exp > 0
      res = res * n % mod if exp.odd?
      n = n * n % mod
      exp >>= 1
    end
    res
  end
end

n, b, k = read_line.split.try { |(n, b, k)|
  {n.to_i64, b.to_i, k.to_i}
}
a = read_line.split.map(&.to_i)
m = Math.log2(n).ceil.to_i + 1

dp_marge = ->(dp1 : Array(Mint), digit : Int64, dp2 : Array(Mint)) {
  dp_res = Array.new(b, Mint.zero)
  pow10 = 10.powmod(digit, b)
  (0...b).each do |i|
    (0...b).each do |j|
      dp_res[(i * pow10 + j) % b] += dp1[i] * dp2[j]
    end
  end
  dp_res
}

doubling = Array.new(1) { [Mint.zero] * b }
a.each { |j|
  doubling[0][j % b] += 1
}
(1..m).each { |i|
  doubling << dp_marge.call(doubling[-1], 2i64**i.pred, doubling[-1])
}

dp = [Mint.zero] * b
dp[0] = 1.to_m
(0..m).select { |i| n.bit(i) == 1 }.each do |i|
  dp = dp_marge.call(dp, 2i64**i, doubling[i])
end
puts dp[0]
