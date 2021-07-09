def count(a, p, x)
  matrix = a.map { |b| b.map { |c| c != -1 ? c : x } }

  matrix.each_index do |k|
    matrix.each_index do |i|
      matrix.each_index do |j|
        matrix[i][j] = {matrix[i][j], matrix[i][k] + matrix[k][j]}.min
      end
    end
  end

  (0...a.size).sum do |i|
    (0...i).count do |j|
      matrix[i][j] <= p
    end
  end
end

n, p, k = read_line.split.map(&.to_i)
a = Array.new(n) { read_line.split.map(&.to_i) }

lower = (1..10**9).bsearch { |x| count(a, p, x) <= k }
upper = (1..10**9).bsearch { |x| count(a, p, x) < k }
if lower && upper
  puts upper - lower
elsif lower.nil?
  puts 0
else
  puts "Infinity"
end
