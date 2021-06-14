n = read_line.to_i

graph = Array.new(n) { [] of Int32 }
stack = Deque(Int32).new
done = [false] * n
n.times do |i|
  a, b = read_line.split.map(&.to_i.pred)
  if a == i || b == i
    stack << i
    done[i] = true
  else
    graph[a] << i
    graph[b] << i
  end
end

ans = [] of Int32
while v = stack.pop?
  ans << v
  graph[v].each do |u|
    unless done[u]
      stack << u
      done[u] = true
    end
  end
end
puts done.all? ? ans.reverse.join('\n', &.succ) : -1
