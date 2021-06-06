n, q = read_line.split.map(&.to_i)
a = Deque.new read_line.split.map(&.to_i)
q.times do
  t, x, y = read_line.split.map(&.to_i.pred)
  case t
  when 0
    a[x], a[y] = a[y], a[x]
  when 1
    a.unshift a[n - 1]
  when 2
    puts a[x]
  end
end
