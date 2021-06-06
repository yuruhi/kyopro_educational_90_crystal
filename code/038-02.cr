require "big"
a, b = read_line.split.map(&.to_big_i)
lcm = a.lcm(b)
puts lcm <= 10i64**18 ? lcm : "Large"
