read_line
a = [-2*10**9] + read_line.split.map(&.to_i).sort + [2*10**9]
read_line.to_i.times do
  b = read_line.to_i
  i = a.bsearch_index { |x| x > b }.not_nil!
  puts a[i - 1..i + 1].min_of { |x| (b - x).abs }
end
