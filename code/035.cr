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

  def pre_order(root : Int32)
    result = Array(Int32).new(size)
    stack = Deque{ {root, -1} }
    while vp = stack.pop?
      vertex, parent = vp
      result << vertex
      self[vertex].reverse_each do |to|
        stack << {to, vertex} if to != parent
      end
    end
    result
  end
end

class LCA
  getter graph : UnweightedGraph
  getter depth : Array(Int32)

  private def dfs(vertex : Int32, par : Int32, dep : Int32) : Nil
    @parent[0][vertex] = par
    @depth[vertex] = dep
    @graph[vertex].each do |edge|
      dfs(edge, vertex, dep + 1) if edge != par
    end
  end

  def initialize(@graph, root : Int32)
    @log2 = Math.log2(size).to_i.succ.as(Int32)
    @depth = Array(Int32).new(size, -1)
    @parent = Array(Array(Int32)).new(@log2) { Array.new(size, 0) }
    dfs(root, -1, 0)
    (0...@log2 - 1).each do |k|
      (0...size).each do |v|
        if @parent[k][v] < 0
          @parent[k + 1][v] = -1
        else
          @parent[k + 1][v] = @parent[k][@parent[k][v]]
        end
      end
    end
  end

  delegate size, to: @graph

  def lca(u : Int32, v : Int32) : Int32
    u, v = v, u if @depth[u] > @depth[v]
    (0...@log2).each do |k|
      v = @parent[k][v] if (@depth[v] - @depth[u]).bit(k) == 1
    end

    return u if u == v

    (0...@log2).reverse_each do |k|
      u, v = @parent[k][u], @parent[k][v] if @parent[k][u] != @parent[k][v]
    end
    @parent[0][u]
  end

  def dist(u : Int32, v : Int32) : Int32
    @depth[u] + @depth[v] - @depth[lca(u, v)] * 2
  end
end

n = read_line.to_i
graph = UnweightedGraph.new(n)
n.pred.times do
  a, b = read_line.split.map(&.to_i.pred)
  graph.add_edge(a, b)
end
lca = LCA.new(graph, 0)

order = graph.pre_order(0)
index = [0] * n
(0...n).each { |i| index[order[i]] = i }

read_line.to_i.times do
  v = read_line.split.map(&.to_i.pred).skip(1).sort_by! { |i| index[i] }
  puts (0...v.size).sum { |i| lca.dist v[i], v[i.succ % v.size] } // 2
end
