record Point, y : Int32, x : Int32 do
  Direction = [Point.new(0, 1), Point.new(0, -1), Point.new(1, 0), Point.new(-1, 0)]

  def +(other : Point)
    Point.new(y + other.y, x + other.x)
  end
end

class Solve
  getter h : Int32, w : Int32

  def initialize
    @h, @w = read_line.split.map(&.to_i)
    @s = Array(String).new(h) { read_line }
    @ans = 0
    @start = Point.new(0, 0)
    @used = Array(Array(Bool)).new(h) { Array(Bool).new(w, false) }
  end

  def run
    Array.each_product((0...h).to_a, (0...w).to_a) do |(y, x)|
      @start = Point.new(y, x)
      @used.map(&.fill(false))
      @used[y][x] = true
      dfs(@start, 0)
    end
    @ans <= 2 ? -1 : @ans
  end

  def dfs(p1, cnt) : Nil
    (0...4).each do |d|
      p2 = p1 + Point::Direction[d]
      next unless (0...h).includes?(p2.y) && (0...w).includes?(p2.x) && @s[p2.y][p2.x] == '.'
      if @start == p2
        @ans = {@ans, cnt + 1}.max
        return
      end
      if !@used[p2.y][p2.x]
        @used[p2.y][p2.x] = true
        dfs(p2, cnt + 1)
        @used[p2.y][p2.x] = false
      end
    end
  end
end

puts Solve.new.run
