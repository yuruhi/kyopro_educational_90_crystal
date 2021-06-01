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

class Combination(T)
  def initialize
    @size = 2
    @factorial = [T.new(1), T.new(1)]
    @inv = [T.zero, T.new(1)]
    @finv = [T.new(1), T.new(1)]
  end

  private def expand_until(n : Int)
    while @size <= n
      @factorial << @factorial[-1] * @size
      @inv << -@inv[T::MOD % @size] * (T::MOD // @size)
      @finv << @finv[-1] * @inv[@size]
      @size += 1
    end
  end

  def factorial(n : Int)
    expand_until(n)
    @factorial[n]
  end

  def inv(n : Int)
    expand_until(n)
    @inv[n]
  end

  def finv(n : Int)
    expand_until(n)
    @finv[n]
  end

  def permutation(n : Int, r : Int)
    (n < r || n < 0 || r < 0) ? T.zero : factorial(n) * finv(n - r)
  end

  def combination(n : Int, r : Int)
    (n < r || n < 0 || r < 0) ? T.zero : factorial(n) * finv(r) * finv(n - r)
  end

  def repeated_combination(n : Int, r : Int)
    (n < 0 || r < 0) ? T.zero : r == 0 ? T.new(1) : combination(n + r - 1, r)
  end
end

n = read_line.to_i
C = Combination(Mint).new
puts (1..n).join('\n') { |k|
  (1..(k == 1 ? n : n.pred // k.pred + 1)).sum { |a|
    C.combination(n - k.pred * a.pred, a)
  }
}
