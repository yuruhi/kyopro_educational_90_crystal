a = Deque(Int32).new
read_line.to_i.times do
  t, x = read_line.split.map(&.to_i)
  case t
  when 2
    a.push x
  when 1
    a.unshift x
  when 3
    puts a[x - 1]
  end
end
