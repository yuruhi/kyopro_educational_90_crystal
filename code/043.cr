struct Point
  Direction = {Point.new(0, 1), Point.new(1, 0), Point.new(0, -1), Point.new(-1, 0)}

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

struct Vertex
  getter p : Point
  getter d : Int32

  def initialize(@p, @d)
  end

  def to_i(w)
    p.y * w * 4 + p.x * 4 + d
  end
end

h, w = read_line.split.map(&.to_i)
start, goal = {0, 1}.map {
  y, x = read_line.split.map(&.to_i.pred)
  Point.new(y, x)
}
s = (1..h).map { read_line }

dist = Array(Int32?).new(h * w * 4, nil)
deque = Deque({Vertex, Int32}).new
(0...4).each do |d|
  e = Vertex.new(start, d)
  dist[e.to_i(w)] = 0
  deque << {e, 0}
end

add_edge = ->(dist_from : Int32, to : Vertex, cost : Int32) {
  dist_to = dist[to.to_i(w)]
  if dist_to.nil? || dist_to > dist_from + cost
    dist_to = dist_from + cost
    dist[to.to_i(w)] = dist_to
    if cost == 0
      deque.push({to, dist_to})
    else
      deque.unshift({to, dist_to})
    end
  end
}

until deque.empty?
  v, dist_now = deque.pop
  dist_from = dist[v.to_i(w)].not_nil!
  next if dist_from < dist_now

  d1 = v.d
  dir = Point::Direction[v.d]
  p1, p2 = v.p, v.p + dir

  if p2.in_range?(h, w) && s[p2.y][p2.x] == '.'
    add_edge.call(dist_from, Vertex.new(p2, d1), 0)
  end
  {d1 - 1, d1 + 1}.each do |d2|
    add_edge.call(dist_from, Vertex.new(p1, d2 % 4), 1)
  end
end

puts (0...4).min_of { |d|
  dist[Vertex.new(goal, d).to_i(w)].not_nil!
}
