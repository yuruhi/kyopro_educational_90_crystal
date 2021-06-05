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

struct Edge2(T)
  include Comparable(Edge2(T))

  property from : Int32
  property to : Int32
  property cost : T

  def initialize(@from : Int32, @to : Int32, @cost : T)
  end

  def <=>(other : Edge2(T))
    {cost, from, to} <=> {other.cost, other.from, other.to}
  end

  def to_s(io) : Nil
    io << '(' << from << ", " << to << ", " << cost << ')'
  end
end

def kruskal(n : Int32, edges : Array(Edge2(T))) : T? forall T
  uf = UnionFind.new(n)
  result = edges.sort.sum do |edge|
    if uf.unite(edge.from, edge.to)
      edge.cost
    else
      T.zero
    end
  end
  uf.size(0) == n ? result : nil
end

n, m = read_line.split.map(&.to_i)
edges = (1..m).map {
  c, l, r = read_line.split.map(&.to_i)
  Edge2.new(l - 1, r, c.to_i64)
}
puts kruskal(n + 1, edges) || -1
