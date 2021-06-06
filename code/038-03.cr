a, b = read_line.split.map(&.to_i64)
begin
  lcm = a // a.gcd(b) * b
  puts lcm <= 10i64**18 ? lcm : "Large"
rescue
  puts "Large"
end
