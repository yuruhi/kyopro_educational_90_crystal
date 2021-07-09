class BipartiteMatching
  getter left : Int32, right : Int32

  def initialize(@left, @right)
    @graph = Array(Array(Int32)).new(left) { [] of Int32 }
    @left_match = Array(Int32?).new(left, nil)
    @right_match = Array(Int32?).new(right, nil)
    @used = Array(Bool).new(left, false)
  end

  def add_edge(l : Int32, r : Int32)
    @graph[l] << r
  end

  private def dfs(v : Int32) : Bool
    return false if @used[v]
    @used[v] = true
    @graph[v].each do |edge|
      if @right_match[edge].nil? || dfs(@right_match[edge].not_nil!)
        @left_match[v], @right_match[edge] = edge, v
        return true
      end
    end
    false
  end

  def solve : Int32
    while (0...left).reduce(false) { |update, i|
            update | (@left_match[i].nil? && dfs(i))
          }
      @used.fill(false)
    end
    left - @left_match.count(&.nil?)
  end

  def each_edge(&block) : Nil
    (0...left).each do |i|
      if j = @left_match[i]
        yield i, j
      end
    end
  end

  def each_edge
    (0...left).each.select { |i| @left_match[i] }.map { |i|
      {i, @left_match[i].not_nil!}
    }
  end
end

record Point, x : Int32, y : Int32 do
  def +(other : Point)
    Point.new(x + other.x, y + other.y)
  end

  def -(other : Point)
    Point.new(x - other.x, y - other.y)
  end

  def *(n : Int32)
    Point.new(x * n, y * n)
  end

  def //(n : Int32)
    Point.new(x // n, y // n)
  end
end

Direction = [
  {1, 0}, {1, 1}, {0, 1}, {-1, 1}, {-1, 0}, {-1, -1}, {0, -1}, {1, -1},
].map { |x, y| Point.new(x, y) }

n, t = read_line.split.map(&.to_i)
a, b = {0, 1}.map {
  Array.new(n) {
    x, y = read_line.split.map(&.to_i)
    Point.new x, y
  }
}

hash = b.zip(0..).to_h
g = BipartiteMatching.new(n, n)
a.each_with_index do |p, i|
  Direction.each do |dir|
    if j = hash[p + dir * t]?
      g.add_edge(i, j)
    end
  end
end

if g.solve == n
  puts "Yes", g.each_edge.join(' ') { |from, to|
    Direction.index((b[to] - a[from]) // t).not_nil!.succ
  }
else
  puts "No"
end
