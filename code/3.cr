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

  private def tree_depth_dfs(v : Int32, p : Int32, dist : Int32, a : Array(Int32))
    a[v] = dist
    self[v].each do |u|
      tree_depth_dfs(u, v, dist + 1, a) if u != p
    end
  end

  def tree_depth(root : Int32)
    a = Array.new(size, 0)
    tree_depth_dfs(root, -1, 0, a)
    a
  end
end

n = read_line.to_i
graph = UnweightedGraph.new(n)
n.pred.times do
  a, b = read_line.split.map(&.to_i.pred)
  graph.add_edge(a, b)
end

v1 = graph.tree_depth(0).each_with_index.max[1]
dist, v2 = graph.tree_depth(v1).each_with_index.max
puts dist + 1
