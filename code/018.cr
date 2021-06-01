TAU = Math::PI * 2
t = read_line.to_i
l, tx, ty = read_line.split.map(&.to_i)
read_line.to_i.times do
  e = read_line.to_i
  angle = TAU / t * e
  y = -Math.sin(angle) * l / 2
  height = l / 2 - Math.cos(angle) * l / 2
  dist = Math.hypot(tx, ty - y)
  puts Math.atan(height / dist) * 360 / TAU
end
