MAX_X = 1000
n = read_line.to_i
imos = Array.new(MAX_X + 1) { Array.new(MAX_X + 1, 0) }
n.times do
  lx, ly, rx, ry = read_line.split.map(&.to_i)
  imos[ly][lx] += 1
  imos[ly][rx] -= 1
  imos[ry][lx] -= 1
  imos[ry][rx] += 1
end

(0..MAX_X).each do |i|
  (1..MAX_X).each do |j|
    imos[i][j] += imos[i][j - 1]
  end
end
(1..MAX_X).each do |i|
  (0..MAX_X).each do |j|
    imos[i][j] += imos[i - 1][j]
  end
end

cnt = [0i64] * n.succ
(0...MAX_X).each do |i|
  (0...MAX_X).each do |j|
    cnt[imos[i][j]] += 1
  end
end
puts cnt.skip(1).join('\n')
