require "big"

module Geometric
  alias Real = BigFloat
  EPS = Real.new(1e-15)

  extend self

  struct Real
    def sgn : Int32
      self < -Geometric::EPS ? -1 : self > Geometric::EPS ? 1 : 0
    end
  end

  struct Vec2
    include Comparable(Vec2)

    property x : Real, y : Real

    def self.zero
      Vec2.new(Real.zero, Real.zero)
    end

    def initialize(x, y)
      @x, @y = Real.new(x), Real.new(y)
    end

    def +
      self
    end

    def -
      Vec2.new(-x, -y)
    end

    {% for op in %w[+ - * /] %}
      def {{op.id}}(other : Vec2)
        Vec2.new(x {{op.id}} other.x, y {{op.id}} other.y)
      end

      def {{op.id}}(other : Real)
        Vec2.new(x {{op.id}} other, y {{op.id}} other)
      end
    {% end %}

    def <=>(other : Vec2)
      {x, y} <=> {other.x, other.y}
    end

    def dot(other : Vec2)
      x * other.y - y * other.x
    end

    def cross(other : Vec2)
      x * other.y - y * other.x
    end
  end

  class Polygon < Array(Vec2)
    def initialize(points : Array(Vec2))
      initialize(points.size)
      concat points
    end

    def initialize
      super
    end

    def initialize(initial_capacity : Int)
      super
    end

    def initialize(size : Int, &block : Int32 -> T)
      super
    end

    def after(i : Int32) : Vec2
      self[i != size - 1 ? i + 1 : 0]
    end

    def area : Real
      (0...size).sum { |i|
        self[i].cross after(i)
      }.abs / 2
    end

    def convex_hull : Polygon
      result = Polygon.new
      points = sort
      points.each do |point|
        while result.size >= 2 && Geometric.iSP(result[-2], result[-1], point) != -1
          result.pop
        end
        result << point
      end
      t = result.size + 1
      points.reverse_each.skip(1).each do |point|
        while result.size >= t && Geometric.iSP(result[-2], result[-1], point) != -1
          result.pop
        end
        result << point
      end
      result.pop
      result
    end
  end

  # AB から見て BC が左に曲がる   : +1
  # AB から見て BC が右に曲がる   : -1
  # ABC, CBA の順に一直線上に並ぶ : +2
  # ACB, BCA の順に一直線上に並ぶ :  0
  # BAC, CAB の順に一直線上に並ぶ : -2
  def iSP(a : Vec2, b : Vec2, c : Vec2) : Int32
    x = (b - a).cross(c - a).sgn
    if x != 0
      x
    elsif (b - a).dot(c - b).sgn > 0
      2
    elsif (a - b).dot(c - a).sgn > 0
      -2
    else
      0
    end
  end
end

n = read_line.to_i
polygon = Geometric::Polygon.new((1..n).map {
  x, y = read_line.split.map(&.to_f)
  Geometric::Vec2.new(x, y)
}).convex_hull

on_line = (0...polygon.size).sum { |i|
  x = (polygon[i].x - polygon.after(i).x).abs.to_i64
  y = (polygon[i].y - polygon.after(i).y).abs.to_i64
  x.gcd(y)
}

puts (polygon.area + on_line / 2 - n + 1).to_i64
