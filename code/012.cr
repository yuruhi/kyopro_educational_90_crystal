class UnionFind
  @d : Array(Int32)

  def initialize(n : Int32)
    @d = Array.new(n, -1)
  end

  def root(x : Int32)
    @d[x] < 0 ? x : (@d[x] = root(@d[x]))
  end

  def unite(x : Int32, y : Int32)
    x = root(x)
    y = root(y)
    return false if x == y
    x, y = y, x if @d[x] > @d[y]
    @d[x] += @d[y]
    @d[y] = x
    true
  end

  def same?(x : Int32, y : Int32)
    root(x) == root(y)
  end

  def size(x : Int32)
    -@d[root(x)]
  end
end

h, w = read_line.split.map(&.to_i)
uf = UnionFind.new(h * w)
red = Array.new(h) { [false] * w }

read_line.to_i.times do |i|
  query = read_line.split.map(&.to_i.pred)
  case query.shift
  when 0
    i, j = query
    red[i][j] = true
    [{i - 1, j}, {i + 1, j}, {i, j - 1}, {i, j + 1}].each do |(i2, j2)|
      if (0...h).includes?(i2) && (0...w).includes?(j2) && red[i2][j2]
        uf.unite(i * w + j, i2 * w + j2)
      end
    end
  when 1
    i1, j1, i2, j2 = query
    puts red[i1][j1] && uf.same?(i1 * w + j1, i2 * w + j2) ? "Yes" : "No"
  end
end
