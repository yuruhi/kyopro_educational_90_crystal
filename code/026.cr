class UnweightedGraph
  getter graph : Array(Array(Int32))

  def initialize(size : Int)
    @graph = Array.new(size) { Array(Int32).new }
  end

  def add_edge(i : Int, j : Int)
    @graph[i] << j
    @graph[j] << i
  end

  delegate size, to: @graph
  delegate :[], to: @graph

  def bipartite_graph : Array(Bool)?
    color = Array(Bool?).new(size, nil)
    queue = Deque.new (0...size).to_a
    while v = queue.shift?
      color[v] = true if color[v].nil?
      flag = color[v].not_nil!
      graph[v].each do |edge|
        if (flag2 = color[edge]).nil?
          color[edge] = !flag
          queue.unshift edge
        else
          return nil if flag == flag2
        end
      end
    end
    color.map(&.not_nil!)
  end
end

n = read_line.to_i
graph = UnweightedGraph.new(n)
n.pred.times do
  a, b = read_line.split.map(&.to_i.pred)
  graph.add_edge(a, b)
end

color = graph.bipartite_graph.not_nil!
puts [true, false].map { |b|
  (0...n).select { |i| color[i] == b }.map(&.succ)
}.max_by(&.size)[0, n // 2].join(' ')
