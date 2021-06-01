# 0.36.0 以降は Math::TAU があります
TAU = Math::PI * 2
n = read_line.to_i
xy = (1..n).map {
  {Int32, Int32}.from read_line.split.map(&.to_i)
}
puts (0...n).max_of { |i|
  angle = (0...n).select { |j| i != j }.map { |j|
    Math.atan2(xy[j][1] - xy[i][1], xy[j][0] - xy[i][0])
  }
  angles = angle.flat_map { |a| [a, a + Math::PI * 2] }.sort
  angle.max_of { |a|
    index = angles.bsearch_index { |b| b >= a + Math::PI }.not_nil!
    {angles[index - 1], angles[index]}.max_of { |b|
      res = (b - a) % TAU
      res > Math::PI ? Math::PI - res : res
    }
  }
} * 360 / TAU
