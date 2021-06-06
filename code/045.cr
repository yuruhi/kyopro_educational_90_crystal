struct Int
  def each_subset(&)
    yield self
    sub = ~-self & self
    loop do
      yield sub
      sub = ~-sub & self
      break if sub == 0
    end
  end
end

n, k = read_line.split.map(&.to_i)
points = (1..n).map { {Int64, Int64}.from read_line.split.map(&.to_i64) }

max_dist = (0...1 << n).map { |set|
  (0...n).select { |i|
    set.bit(i) == 1
  }.combinations(2).max_of? { |(i, j)|
    (points[i][0] - points[j][0])**2 + (points[i][1] - points[j][1])**2
  } || 0i64
}

dp = (0...1 << n).map { [10i64 ** 18] * -~k }
dp[0][0] = 0
(1...1 << n).each do |set|
  (0...k).each do |i|
    set.each_subset do |sub|
      dp[set][i + 1] = {dp[set][i + 1], {dp[set & ~sub][i], max_dist[sub]}.max}.min
    end
  end
end
puts dp[-1][-1]
