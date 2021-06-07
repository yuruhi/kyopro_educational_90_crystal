struct Edge(T)
  include Comparable(Edge(T))

  property to : Int32
  property cost : T

  def initialize(@to : Int32, @cost : T)
  end

  def <=>(other : Edge(T))
    {cost, to} <=> {other.cost, other.to}
  end
end

class Graph(T)
  getter graph : Array(Array(Edge(T)))

  def initialize(size : Int)
    @graph = Array.new(size) { Array(Edge(T)).new }
  end

  def add_edge(i : Int, j : Int, cost : T)
    @graph[i] << Edge.new(j, cost)
    @graph[j] << Edge.new(i, cost)
  end

  delegate size, to: @graph
  delegate :[], to: @graph

  def bfs01(starts : Enumerable(Int32))
    queue = Deque({Int32, T}).new
    dist = Array(T?).new(size, nil)
    starts.each do |start|
      queue << {start, T.zero}
      dist[start] = T.zero
    end

    until queue.empty?
      v, d = queue.pop
      dist_v = dist[v].not_nil!
      next if dist_v < d
      self[v].each do |edge|
				dist_to = dist[edge.to]
        if dist_to.nil? || dist_to.not_nil! > dist_v + edge.cost
          dist_to = dist_v + edge.cost
          dist[edge.to] = dist_to
          if edge.cost == 0
            queue.push({edge.to, dist_to})
          else
            queue.unshift({edge.to, dist_to})
          end
        end
      end
    end

    dist
  end
end

struct Point
  property y : Int32
  property x : Int32

  def initialize(@y, @x)
  end

  def +(other : Point)
    Point.new(y + other.y, x + other.x)
  end

  def in_range?(h, w)
    (0...h).includes?(y) && (0...w).includes?(x)
  end
end

Direction = {Point.new(0, 1), Point.new(1, 0), Point.new(0, -1), Point.new(-1, 0)}

h, w = read_line.split.map(&.to_i)
start, goal = {0, 1}.map {
  y, x = read_line.split.map(&.to_i.pred)
  Point.new(y, x)
}
s = (1..h).map { read_line }

to_vertex = ->(p : Point, d : Int32) {
  p.y * w * 4 + p.x * 4 + d
}

graph = Graph(Int32).new(h * w * 4)
(0...h).each do |y|
  (0...w).each do |x|
    next if s[y][x] == '#'
    p1 = Point.new(y, x)

    Direction.each_with_index do |dir, d|
      v1 = to_vertex.call(p1, d)
      p2 = p1 + dir
      if p2.in_range?(h, w)
        graph.add_edge(v1, to_vertex.call(p2, d), 0)
      end
      {d - 1, d + 1}.each do |d2|
        graph.add_edge(v1, to_vertex.call(p1, d2 % 4), 1)
      end
    end
  end
end
dist = graph.bfs01(
  (0...4).map { |d| to_vertex.call(start, d) }
)
puts (0...4).min_of { |d|
  dist[to_vertex.call(goal, d)].not_nil!
}
