class Array(T)
  def mex
    result = 0
    sort.each do |i|
      return result if result < i
      result = i.succ
    end
    result
  end
end

grundy = Hash({Int32, Int32}, Int32).new { |hash, (w, b)|
  if w == 0 && b <= 1
    0
  else
    a = [] of Int32
    a << hash[{w - 1, b + w}] if w >= 1
    a.concat (1..b // 2).map { |k| hash[{w, b - k}] }
    hash[{w, b}] = a.mex
  end
}

n = read_line.to_i
w = read_line.split.map(&.to_i)
b = read_line.split.map(&.to_i)
puts w.zip(b).reduce(0) { |acc, (w, b)|
  acc ^ grundy[{w, b}]
} > 0 ? "First" : "Second"
