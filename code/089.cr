class BinaryIndexedTree(T)
  getter size : Int32

  def initialize(@size)
    @a = Array(T).new(@size + 1, T.zero)
  end

  def add(i : Int, x)
    i += 1
    while i <= size
      @a[i] += x
      i += i & -i
    end
  end

  # sum of a[0...i]
  def left_sum(i : Int)
    sum = T.zero
    while i > 0
      sum += @a[i]
      i -= i & -i
    end
    sum
  end

  def [](start : Int, count : Int)
    left_sum(start + count) - left_sum(start)
  end

  def [](range : Range)
    self[*Indexable.range_to_index_and_count(range, size) || raise IndexError.new]
  end
end

MOD = 1000000007
n, k = read_line.split.try { |(n, k)| {n.to_i, k.to_i64} }
a = read_line.split.map(&.to_i)
values = a.uniq.sort
a.map! { |x| values.bsearch_index { |y| y >= x }.not_nil! }

bit = BinaryIndexedTree(Int32).new(n)
right, cnt = 0, 0i64
min_left = (0...n).to_a
(0...n).each do |left|
  while right < n
    s = bit[a[right] + 1..]
    break if cnt + s > k
    min_left[right] = left
    bit.add(a[right], 1)
    cnt += s
    right += 1
  end

  cnt -= bit[...a[left]]
  bit.add(a[left], -1)
end

culsum = [0i64] * (n + 2)
culsum[1] = 1
min_left.each_with_index(1) do |left, i|
  culsum[i + 1] = (culsum[i] * 2 - culsum[left]) % MOD
end
puts (culsum[-1] - culsum[-2]) % MOD
