n, m = read_line.split.map(&.to_i)
graph = Array.new(n) { [] of Int32 }
m.times do
  a, b = read_line.split.map(&.to_i.pred)
  graph[a] << b
  graph[b] << a
end
puts graph.each_with_index.count { |a, i|
  a.one? { |j| i > j }
}
