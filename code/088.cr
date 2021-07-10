class Solve
  getter n : Int32, q : Int32, a : Array(Int32)

  def initialize
    @n, @q = read_line.split.map(&.to_i)
    @a = read_line.split.map(&.to_i)
    @no = Array(Set(Int32)).new(n) { Set(Int32).new }
    q.times do
      x, y = read_line.split.map(&.to_i.pred)
      @no[y] << x
    end

    @set = Set(Int32).new
    @memo = Array(Set(Int32)?).new(8889, nil)
  end

  def dfs(i : Int32, sum : Int32) : Nil
    if (set2 = @memo[sum]) && @set != set2
      puts @set.size, @set.join(' ', &.succ)
      puts set2.size, set2.join(' ', &.succ)
      exit
    else
      @memo[sum] = @set.dup
    end

    return if i == n

    unless @set.intersects?(@no[i])
      @set.add i
      dfs(i + 1, sum + a[i])
      @set.delete i
    end
    dfs(i + 1, sum)
  end
end

Solve.new.dfs(0, 0)
