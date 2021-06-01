# ac-library.cr by hakatashi https://github.com/google/ac-library.cr
#
# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

module AtCoder
  # Implements standard priority queue like [std::priority_queue](https://en.cppreference.com/w/cpp/container/priority_queue).
  #
  # ```
  # q = AtCoder::PriorityQueue(Int64).new
  # q << 1_i64
  # q << 3_i64
  # q << 2_i64
  # q.pop # => 3
  # q.pop # => 2
  # q.pop # => 1
  # ```
  class PriorityQueue(T)
    getter heap : Array(T)

    def initialize
      initialize(&.itself)
    end

    # Initializes queue with the custom comperator.
    #
    # ```
    # q = AtCoder::PriorityQueue(Int64).new { |n| -n }
    # q << 1_i64
    # q << 3_i64
    # q << 2_i64
    # q.pop # => 1
    # q.pop # => 2
    # q.pop # => 3
    # ```
    def initialize(&block : T -> (Int8 | Int16 | Int32 | Int64 | UInt8 | UInt16 | UInt32 | UInt64))
      @heap = Array(T).new
      @priority_proc = block
    end

    # Pushes value into the queue.
    def push(v : T)
      @heap << v
      index = @heap.size - 1
      while index != 0
        parent = (index - 1) // 2
        if @priority_proc.call(@heap[parent]) >= @priority_proc.call(@heap[index])
          break
        end
        @heap[parent], @heap[index] = @heap[index], @heap[parent]
        index = parent
      end
    end

    # Alias of `push`
    def <<(v : T)
      push(v)
    end

    # Pops value from the queue.
    def pop
      if @heap.size == 0
        return nil
      end
      if @heap.size == 1
        return @heap.pop
      end
      ret = @heap.first
      @heap[0] = @heap.pop
      index = 0
      while index * 2 + 1 < @heap.size
        child = if index * 2 + 2 < @heap.size && @priority_proc.call(@heap[index * 2 + 1]) < @priority_proc.call(@heap[index * 2 + 2])
                  index * 2 + 2
                else
                  index * 2 + 1
                end
        if @priority_proc.call(@heap[index]) >= @priority_proc.call(@heap[child])
          break
        end
        @heap[child], @heap[index] = @heap[index], @heap[child]
        index = child
      end
      ret
    end

    # Returns `true` if the queue is empty.
    delegate :empty?, to: @heap

    # Returns size of the queue.
    delegate :size, to: @heap
  end
end

struct Edge(T)
  include Comparable(Edge(T))

  property to : Int32
  property cost : T

  def initialize(@to : Int32, @cost : T)
  end

  def <=>(other : Edge(T))
    {cost, to} <=> {other.cost, other.to}
  end

  def to_s(io : IO) : Nil
    io << '(' << to << ", " << cost << ')'
  end
end

class Graph(T)
  getter graph : Array(Array(Edge(T)))

  def initialize(size : Int)
    @graph = Array.new(size) { Array(Edge(T)).new }
  end

  def add_edge(i : Int, j : Int, cost : T)
    @graph[i] << Edge.new(j, cost)
    @graph[j] << Edge.new(i, cost)
  end

  delegate size, to: @graph
  delegate :[], to: @graph

  def dijkstra(start : Int32)
    queue = AtCoder::PriorityQueue({Int32, T}).new { |(vertex, dist)| -dist }
    queue << {start, T.zero}
    dist = Array(T?).new(size, nil)
    dist[start] = T.zero

    until queue.empty?
      vertex, d = queue.pop.not_nil!
      dist_v = dist[vertex].not_nil!
      next if dist_v < d
      self[vertex].each do |edge|
        if dist[edge.to].nil? || dist[edge.to].not_nil! > dist_v + edge.cost
          dist[edge.to] = dist_v + edge.cost
          queue << {edge.to, dist_v + edge.cost}
        end
      end
    end

    dist
  end

  def dijkstra!(start : Int32)
    dijkstra(start).map(&.not_nil!)
  end
end

n, m = read_line.split.map(&.to_i)
g = Graph(Int32).new(n)
m.times do
  a, b, c = read_line.split.map(&.to_i)
  g.add_edge(a - 1, b - 1, c)
end
dist_1 = g.dijkstra!(0)
dist_n = g.dijkstra!(n - 1)
puts dist_1.zip(dist_n).join('\n') { |d1, dn| d1 + dn }
