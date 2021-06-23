record Point, y : Int32, x : Int32 do
  Direction = [Point.new(0, 1), Point.new(0, -1), Point.new(1, 0), Point.new(-1, 0)]

  def +(other : Point)
    Point.new(y + other.y, x + other.x)
  end
end

record State, point : Point, vis : Int32, cnt : Int32

h, w = read_line.split.map(&.to_i)
s = Array.new(h) { read_line }

ans = -1
Array.each_product((0...h).to_a, (0...w).to_a) do |(y, x)|
  start = Point.new(y, x)
  queue = Deque{State.new(start, 1 << (y * w + x), 0)}

  while state = queue.pop?
    (0...4).each do |d|
      p2 = state.point + Point::Direction[d]
      next unless (0...h).includes?(p2.y) && (0...w).includes?(p2.x) && s[p2.y][p2.x] == '.'
      if start == p2
        ans = {ans, state.cnt + 1}.max
        break
      end
      i2 = p2.y * w + p2.x
      if state.vis.bit(i2) == 0
        queue << State.new(p2, state.vis | 1 << i2, state.cnt + 1)
      end
    end
  end
end
puts ans == 2 ? -1 : ans
