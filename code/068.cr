# require "atcoder/DSU"
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
  # Implements [atcoder::dsu](https://atcoder.github.io/ac-library/master/document_en/dsu.html).
  #
  # ```
  # dsu = AtCoder::DSU.new(10)
  # dsu.merge(0, 2)
  # dsu.merge(4, 2)
  # dsu.same(0, 4) # => true
  # dsu.size(4)    # => 3
  # ```
  class DSU
    getter parents : Array(Int64)
    getter sizes : Array(Int64)
    getter size : Int64

    def initialize(@size)
      @parents = Array.new(size, &.to_i64)
      @sizes = Array.new(size, 1_i64)
    end

    # Implements atcoder::dsu.leader(node).
    def leader(node)
      until @parents[node] == node
        @parents[node] = @parents[@parents[node]]
        node = @parents[node]
      end
      node
    end

    # Implements atcoder::dsu.merge(a, b).
    def merge(a, b)
      leader_a = leader(a.to_i64)
      leader_b = leader(b.to_i64)
      unless leader_a == leader_b
        if @sizes[leader_a] < @sizes[leader_b]
          leader_a, leader_b = leader_b, leader_a
        end
        @parents[leader_b] = leader_a
        @sizes[leader_a] += @sizes[leader_b]
      end
    end

    # Implements atcoder::dsu.same(a, b).
    def same(a, b)
      leader(a) == leader(b)
    end

    # Implements atcoder::dsu.size().
    def size(node)
      @sizes[leader(node)]
    end

    # Implements atcoder::dsu.groups().
    # This method returns `Set` instead of list.
    def groups
      groups = Hash(Int64, Set(Int64)).new { |h, k| h[k] = Set(Int64).new }
      @size.times do |i|
        groups[leader(i)] << i
      end
      groups.values.to_set
    end
  end
end

n = read_line.to_i
q = read_line.to_i

# {x, y, v, ambiguous?}
query = [] of {Int32, Int32, Int64, Bool}
dsu = AtCoder::DSU.new(n.to_i64)
sum = Array(Int64?).new(n - 1, nil)

q.times do
  t, x, y, v = read_line.split.map(&.to_i)
  x -= 1; y -= 1; v = v.to_i64
  if t == 0
    dsu.merge(x, y)
    sum[x] = v
  else
    query << {x, y, v, !dsu.same(x, y)}
  end
end

a = [0i64] * n
(0...n).each do |i|
  if i == 0 || sum[i - 1].nil?
    a[i] = 0i64
  else
    a[i] = sum[i - 1].not_nil! - a[i - 1]
  end
end

query.each do |x, y, v, ambiguous|
  if ambiguous
    puts "Ambiguous"
  else
    diff = a[x] - v
    diff *= -1 if (y - x).odd?
    puts a[y] - diff
  end
end
