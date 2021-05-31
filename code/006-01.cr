n, k = read_line.split.map(&.to_i)
s = read_line
next_index = ('a'..'z').map { |c|
  prev_index = n
  (0...n).reverse_each.map { |i|
    if s[i] == c
      prev_index = i
    else
      prev_index
    end
  }.to_a.reverse
}

index = 0
puts (1..k).join { |size|
  ('a'..'z').find { |char|
    next_index[char - 'a'][index] <= n - (k - size + 1)
  }.not_nil!.tap { |char|
    index = next_index[char - 'a'][index] + 1
  }
}
