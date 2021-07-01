struct Mint
  MOD = 998244353i64

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

  def + : self
    self
  end

  def - : self
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

  def inv
    Mint.raw(1) / self
  end

  delegate to_s, to: @value
  delegate inspect, to: @value
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

# reference : https://kopricky.github.io/code/FFTs/ntt.html
class NTT
  ROOT = 3

  private def self.ntt(a : Array(T), rev = false) forall T
    return a if a.size == 1
    b = Array.new(a.size, T.zero)
    r = T::MOD.pred // a.size
    r = T::MOD.pred - r if rev
    s = T.new(ROOT) ** r
    kp = Array.new(a.size // 2 + 1, T.new(1))
    (1...kp.size).each { |i| kp[i] = kp[i - 1] * s }

    i, l = 1, a.size // 2
    while i < a.size
      r = 0
      (0...l).each do |j|
        s = kp[i * j]
        (0...i).each do |k|
          p, q = a[k + r], a[k + r + a.size // 2]
          b[k + 2 * r] = p + q
          b[k + 2 * r + i] = (p - q) * s
        end
        r += i
      end
      a, b = b, a
      i <<= 1; l >>= 1
    end
    if rev
      s = T.new(a.size).inv
      a.map! { |x| x * s }
    end
    a
  end

  def self.convolution(a : Array(T), b : Array(T)) forall T
    size = a.size + b.size - 1
    t = Math.pw2ceil(size)
    aa = a + Array.new(t - a.size, T.zero)
    bb = b + Array.new(t - b.size, T.zero)
    c = ntt(aa).zip(ntt(bb)).map { |x, y| x * y }
    ntt(c, true).first(size)
  end
end

C = Combination(Mint).new

a, b, c, n = read_line.split.map(&.to_i)
x, y, z = read_line.split.map(&.to_i)

ca = Array.new(a + 1, Mint.zero)
cb = Array.new(b + 1, Mint.zero)
cc = Array.new(c + 1, Mint.zero)
(n - y..a).each { |i| ca[i] = C.combination(a, i) }
(n - z..b).each { |i| cb[i] = C.combination(b, i) }
(n - x..c).each { |i| cc[i] = C.combination(c, i) }

ab = NTT.convolution(ca, cb)
puts (0..n).sum { |i|
  ab.fetch(i, Mint.zero) * cc.fetch(n - i, Mint.zero)
}
