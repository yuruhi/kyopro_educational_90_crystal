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

  private def subtree_size_dfs(v : Int32, p : Int32, result : Array(Int32)) : Int32
    result[v] = 1 + self[v].sum do |u|
      u != p ? subtree_size_dfs(u, v, result) : 0
    end
  end

  def subtree_size(root : Int32)
    result = Array.new(size, 0)
    subtree_size_dfs(root, -1, result)
    result
  end
end

n = read_line.to_i
graph = UnweightedGraph.new(n)
n.pred.times do
  a, b = read_line.split.map(&.to_i.pred)
  graph.add_edge(a, b)
end
puts graph.subtree_size(0).skip(1).sum { |size|
  size.to_i64 * (n - size)
}
