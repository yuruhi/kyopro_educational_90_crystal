n, q = read_line.split.map(&.to_i)
a = read_line.split.map(&.to_i)
i = 0
q.times do
  t, x, y = read_line.split.map(&.to_i.pred)
  case t
  when 0
    a[(i + x) % n], a[(i + y) % n] = a[(i + y) % n], a[(i + x) % n]
  when 1
		i -= 1
  when 2
		puts a[(i + x) % n]
  end
end
