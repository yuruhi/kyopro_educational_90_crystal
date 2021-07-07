n, m = read_line.split.map(&.to_i)
graph = Array.new(n) { |i| [i] }
m.times do
  a, b = read_line.split.map(&.to_i.pred)
  graph[a] << b
  graph[b] << a
end

sqrt = Math.sqrt(n * 2).to_i
graph_large = graph.map &.select { |v| graph[v].size > sqrt }

color = [1] * n
color_lazy = [{-1, 1}] * n # {time, color}

read_line.to_i.times do |now|
  x, y = read_line.split.map(&.to_i)
  x -= 1
  if graph[x].size > sqrt
    puts color[x]
  else
    puts graph[x].max_of { |v| color_lazy[v] }[1]
  end
  graph_large[x].each { |v| color[v] = y }
  color_lazy[x] = {now, y}
end
