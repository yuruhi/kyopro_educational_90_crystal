_, l = read_line.split.map(&.to_i)
k = read_line.to_i
a = read_line.split.map(&.to_i) + [l]
puts (1..10**9).bsearch { |len|
  last, cnt = 0, 0
  a.each do |i|
    if i - last >= len
      cnt += 1
      last = i
    end
  end
  cnt < k + 1
}.not_nil! - 1
