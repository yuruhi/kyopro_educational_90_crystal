class Solve
  getter n : Int32, m : Int32, k : Int32

  def initialize
    @n, @m, @k = read_line.split.map(&.to_i)
    @graph = Array(Array(Int32)).new(n) { [] of Int32 }
    @deg = Array(Int32).new(n, 0)
    m.times do
      a, b = read_line.split.map(&.to_i.pred)
      @graph[a] << b
      @deg[b] += 1
    end
    @ans = [] of Array(Int32)
    @perm = [] of Int32
    @stack = [] of Int32
  end

  def run
    @stack = (0...n).select { |i| @deg[i] == 0 }
    dfs
    puts -1
  end

  def dfs
    if @perm.size == n
      @ans << @perm.dup
      if @ans.size == k
        @ans.each { |t| puts t.join(' ', &.succ) }
        exit
      end
      return
    elsif @stack.size == 0
      puts -1
      exit
    end

    (0...@stack.size).reverse_each do |i|
      v = @stack.delete_at(i)
      @perm << v
      @graph[v].each do |u|
        @deg[u] -= 1
        @stack << u if @deg[u] == 0
      end

      dfs

      @graph[v].each do |u|
        @stack.pop if @deg[u] == 0
        @deg[u] += 1
      end
      @perm.pop
      @stack.insert(i, v)
    end
  end
end

Solve.new.run
