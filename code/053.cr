class Manager
  getter memo = {} of Int32 => Int32

  delegate :[]=, to: @memo
  delegate has_key?, to: @memo

  def ask(x : Int32)
    if @memo.has_key?(x)
      @memo[x]
    else
      puts "? #{x + 1}"; STDOUT.flush
      res = read_line.to_i
      exit(1) if res == -1
      @memo[x] = res
    end
  end

  def answer(val : Int32)
    puts "! #{val}"; STDOUT.flush
  end
end

read_line.to_i.times do
  s = Manager.new
  n = read_line.to_i

  if n == 1
    s.answer(s.ask(0))
    next
  end

  fib = [1, 1]
  while fib[-1] <= n
    fib << fib[-1] + fib[-2]
  end
  m = fib[-1] - 1
  (n...m).each { |i| s[i] = -i }

  range = (0..m - 1)
  fib_i = fib.size - 3
  while range.size >= 3
    li = range.begin + (fib[fib_i] - 1)
    ri = range.end - (fib[fib_i] - 1)
    left, right = s.ask(li), s.ask(ri)
    range = if left >= right
              range.begin..ri - 1
            else
              li + 1..range.end
            end
    fib_i -= 1
  end
  s.answer [s.ask(range.begin), s.ask(range.end)].max
end
