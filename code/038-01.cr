a, b = read_line.split.map(&.to_i64)
c = a // a.gcd(b)
if b <= 10i64**18 // c
  puts b * c
else
  puts "Large"
end
