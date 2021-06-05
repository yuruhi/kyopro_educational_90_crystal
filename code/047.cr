class RollingHash
  private MASK30 = (1u64 << 30) - 1
  private MASK31 = (1u64 << 31) - 1
  private MASK61 = (1u64 << 61) - 1
  MOD    = MASK61

  private def mul(a : UInt64, b : UInt64)
    au, ad = a >> 31, a & MASK31
    bu, bd = b >> 31, b & MASK31
    mid = ad * bu + au * bd
    midu, midd = mid >> 30, mid & MASK30
    au * bu * 2 + midu + (midd << 31) + ad * bd
  end

  private def mod(a : UInt64)
    x = (a >> 61) + (a & MASK61)
    x -= MOD if x >= MOD
    x
  end

  getter size : Int32

  def initialize(s : String, base : UInt64 = 10007u64)
    initialize(s.size, s.each_char, base, &.ord)
  end

  def initialize(a : Array(Int), base : UInt64 = 10007u64)
    initialize(a.size, a, base, &.itself)
  end

  def initialize(@size, a : Enumerable, base : UInt64 = 10007u64, &)
    @pow = Array(UInt64).new(size + 1, 1)
    @hash = Array(UInt64).new(size + 1, 0)
    a.each_with_index do |x, i|
      @pow[i + 1] = mod(mul(@pow[i], base))
      @hash[i + 1] = mod(mul(@hash[i], base) + yield(x))
    end
  end

  def [](start : Int, count : Int)
    mod(@hash[start + count] + MOD * 4 - mul(@hash[start], @pow[count]))
  end

  def [](range : Range)
    self[*Indexable.range_to_index_and_count(range, size) || raise IndexError.new]
  end
end

n = read_line.to_i
s, t = {0, 1}.map {
  read_line.chars.map { |c| "RGB".index(c).not_nil! }
}
s_rh = RollingHash.new(s)
puts (0...3).sum { |k|
  t_rh = RollingHash.new(n, t) { |i| i == k ? i : 3 ^ k ^ i }
  (-n + 1...n).count do |i|
    if i < 0
      s_rh[-i, n + i] == t_rh[0, n + i]
    else
      s_rh[0, n - i] == t_rh[i, n - i]
    end
  end
}
