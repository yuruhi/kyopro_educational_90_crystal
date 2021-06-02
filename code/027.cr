n = read_line.to_i
set = Set(String).new
puts (1..n).select {
  s = read_line
  if set.includes?(s)
    false
  else
    set << s
    true
  end
}.join('\n')
