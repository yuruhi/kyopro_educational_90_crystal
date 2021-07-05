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

  getter value : Int64

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

  def ==(m : self)
    value == m.value
  end

  def ==(m)
    value == m
  end

  def +
    self
  end

  def -
    Mint.raw(value != 0 ? MOD - value : 0i64)
  end

  def +(v)
    self + Mint.new(v)
  end

  def +(m : self)
    x = value + m.value
    x -= MOD if x >= MOD
    Mint.raw(x)
  end

  def -(v)
    self - Mint.new(v)
  end

  def -(m : self)
    x = value - m.value
    x += MOD if x < 0
    Mint.raw(x)
  end

  def *(v)
    self * Mint.new(v)
  end

  def *(m : self)
    Mint.new(value * m.value)
  end

  def /(v)
    self / Mint.new(v)
  end

  def /(m : self)
    raise DivisionByZeroError.new if m.value == 0
    a, b, u, v = m.value, MOD, 1i64, 0i64
    while b != 0
      t = a // b
      a -= t * b
      a, b = b, a
      u -= t * v
      u, v = v, u
    end
    Mint.new(value * u)
  end

  def **(exponent : Int)
    t, x = self, Mint.raw(1i64)
    while exponent > 0
      x *= t if exponent & 1 == 1
      t *= t
      exponent >>= 1
    end
    x
  end

  delegate to_s, to: @value
  delegate inspect, to: @value
end

struct Int
  def to_m
    Mint.new(self)
  end
end

l, r = read_line.split.map(&.to_i64)
puts (1..19).sum { |d|
  dl = {10i64**d.pred, l}.max
  dr = d < 19 ? {10i64**d - 1, r}.min : r
  if dl <= dr
    cnt = (dr.to_m + dl) * (dr.to_m - dl + 1) / 2
    cnt * d
  else
    Mint.zero
  end
}
