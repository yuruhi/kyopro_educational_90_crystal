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

dp = [Mint.zero] * m
dp[0] = 1.to_m
(0...h).each do |i|
  (0...w).each do |j|
    dp2 = [Mint.zero] * m
    (0...m).each do |k|
      next if dp[k] == Mint.zero
      bit = a[k]
      dp2[next1[k]] += dp[k]
      next if grid[i][j] == '#'
      unless (i != 0 && j != 0 && bit.bit(0) == 1) ||
             (i != 0 && bit.bit(1) == 1) ||
             (i != 0 && j != w - 1 && bit.bit(2) == 1) ||
             (j != 0 && bit.bit(w) == 1)
        dp2[next2[k].not_nil!] += dp[k]
      end
    end
    dp = dp2
  end
end
puts dp.sum
