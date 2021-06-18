n, k = read_line.split
k.to_i.times do
	n = n.to_i64(8).to_s(9).gsub('8', '5')
end
puts n
