MOD = 10**9 + 7

class Graph
  def initialize(size, @color : Array(Char))
    @graph = Array(Array(Int32)).new(size) { [] of Int32 }
  end

  def add_edge(u, v)
    @graph[u] << v
    @graph[v] << u
  end

  def run
    dfs(0, -1)[2] % MOD
  end

  def dfs(v, p)
    val1, val2 = 1i64, 1i64
    @graph[v].each do |u|
      next if u == p
      a, b, ab = dfs(u, v)
      val1 *= (@color[v] == 'a' ? a : b) + ab
      val2 *= a + b + ab * 2
      val1 %= MOD
      val2 %= MOD
    end

    if @color[v] == 'a'
      {val1, 0i64, val2 - val1}
    else
      {0i64, val1, val2 - val1}
    end
  end
end

n = read_line.to_i
c = read_line.split.map(&.[0])
g = Graph.new(n, c)
n.pred.times do
  a, b = read_line.split.map(&.to_i.pred)
  g.add_edge(a, b)
end
puts g.run
