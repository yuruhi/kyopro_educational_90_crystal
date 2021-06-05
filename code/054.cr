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

  def bfs(start : Int32)
    queue = Deque{start}
    dist = Array(Int32?).new(size, nil)
    dist[start] = 0
    while v = queue.pop?
      graph[v].each do |edge|
        if dist[edge].nil?
          dist[edge] = dist[v].not_nil! + 1
          queue.unshift edge
        end
      end
    end
    dist
  end
end

n, m = read_line.split.map(&.to_i)
g = UnweightedGraph.new(n + m)
m.times do |i|
  k = read_line.to_i
  a = read_line.split.map(&.to_i.pred)
  a.each do |j|
    g.add_edge(j, n + i)
  end
end
puts g.bfs(0).first(n).join('\n') { |x| x ? x // 2 : -1 }
