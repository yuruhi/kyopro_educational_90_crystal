class UnweightedGraph
  getter graph : Array(Array(Int32))

  def initialize(size : Int)
    @graph = Array.new(size) { Array(Int32).new }
  end

  def add_edge(v, u)
    @graph[v] << u
    @graph[u] << v
  end

  delegate size, to: @graph
  delegate :[], to: @graph
end

class ReRooting(T, GraphType)
  getter graph : UnweightedGraph

  def initialize(size : Int32)
    @graph = GraphType.new(size)
    @dp = Array(Array(T)).new
    @result = Array(T).new
  end

  delegate size, to: @graph
  delegate add_edge, to: @graph

  private def dfs(v : Int32, p : Int32) : T
    graph[v].each_with_index.select { |(u, i)| u != p }.reduce(T.new) { |acc, (u, i)|
      acc + (@dp[v][i] = dfs(u, v))
    }.add_root(v)
  end

  private def bfs(v : Int32, p : Int32, dp_par : T) : Nil
    graph[v].each_with_index do |u, i|
      @dp[v][i] = dp_par if u == p
    end

    n = graph[v].size
    dp_left = Array.new(n + 1, T.new)
    (0...n).each do |i|
      dp_left[i + 1] = dp_left[i] + @dp[v][i]
    end
    dp_right = Array.new(n + 1, T.new)
    (0...n).reverse_each do |i|
      dp_right[i] = dp_right[i + 1] + @dp[v][i]
    end
    @result[v] = dp_left.last.add_root(v)

    graph[v].each_with_index do |u, i|
      bfs(u, v, (dp_left[i] + dp_right[i + 1]).add_root(v)) if u != p
    end
  end

  def solve : Array(T)
    @dp = Array.new(size) { |i| Array.new(@graph[i].size, T.new) }
    @result = Array.new(size, T.new)
    dfs(0, -1)
    bfs(0, -1, T.new)
    @result
  end
end

struct DP
  getter val : Int64
  getter cnt : Int32

  def initialize
    @val, @cnt = 0i64, 0
  end

  def initialize(@val, @cnt)
  end

  def +(other : self) : self
    DP.new(val + other.val, cnt + other.cnt)
  end

  def add_root(v : Int32) : self
    DP.new(val + cnt, cnt + 1)
  end
end

n = read_line.to_i
dp = ReRooting(DP, UnweightedGraph).new(n)
(0...n - 1).each do
  a, b = read_line.split.map(&.to_i.pred)
  dp.add_edge(a, b)
end
puts dp.solve.sum(&.val) // 2
