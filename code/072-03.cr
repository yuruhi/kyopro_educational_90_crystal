struct Point
  property y : Int32, x : Int32
  class_property! h : Int32, w : Int32

  Direction = [Point.new(0, 1), Point.new(0, -1), Point.new(1, 0), Point.new(-1, 0)]

  def initialize(@y, @x)
  end

  def initialize(i)
    initialize(i // Point.w, i % Point.w)
  end

  def +(other : Point)
    Point.new(y + other.y, x + other.x)
  end

  def in_range?
    (0...Point.h).includes?(y) && (0...Point.w).includes?(x)
  end

  def to_i
    y * Point.w + x
  end

  def adjacent_in_range : Nil
    Direction.each do |dir|
      point = self + dir
      yield point if point.in_range?
    end
  end

  def adjacent_in_range
    Direction.each.map { |dir| self + dir }.select(&.in_range?)
  end
end

module Indexable(T)
  def [](point : Point)
    self[point.y][point.x]
  end
end

class Array(T)
  def []=(point : Point, value)
    self[point.y][point.x] = value
  end
end

h, w = read_line.split.map(&.to_i)
Point.h, Point.w = h, w
s = (1..h).map { read_line }
n = h * w
ans = (0...n).max_of { |start|
  dp = Array.new(1 << n) { [false] * n }
  dp[1 << start][start] = true

  (0...1 << n).each do |bit|
    (0...n).each do |i|
      next unless dp[bit][i]
      p1 = Point.new(i)
      next if s[p1] == '#'
      p1.adjacent_in_range do |p2|
        next if s[p2] == '#'
        j = p2.to_i
        dp[bit | 1 << j][j] = true if bit.bit(j) == 0
      end
    end
  end
  Point.new(start).adjacent_in_range.max_of? { |p2|
    j = p2.to_i
    (0...1 << n).each.select { |bit| dp[bit][j] }.max_of?(&.popcount) || -1
  } || -1
}
puts ans <= 2 ? -1 : ans
