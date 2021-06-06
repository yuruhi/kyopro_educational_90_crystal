n, k = read_line.split.map(&.to_i)
a = read_line.split.map(&.to_i)

table = Hash(Int32, Int32).new(0)
cnt, r, ans = 0, 0, 0
(0...n).each do |l|
  while r < n && (cnt < k || table[a[r]] > 0)
    cnt += 1 if table[a[r]] == 0
    table[a[r]] += 1
    r += 1
  end

  ans = {ans, r - l}.max

  cnt -= 1 if table[a[l]] == 1
  table[a[l]] -= 1
end
puts ans
