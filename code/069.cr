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

# require "./Math.cr"
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
  # Implements [ACL's Math library](https://atcoder.github.io/ac-library/master/document_en/math.html)
  module Math
    def self.extended_gcd(a, b)
      last_remainder, remainder = a.abs, b.abs
      x, last_x, y, last_y = 0_i64, 1_i64, 1_i64, 0_i64
      while remainder != 0
        new_last_remainder = remainder
        quotient, remainder = last_remainder.divmod(remainder)
        last_remainder = new_last_remainder
        x, last_x = last_x - quotient * x, x
        y, last_y = last_y - quotient * y, y
      end

      return last_remainder, last_x * (a < 0 ? -1 : 1)
    end

    # Implements atcoder::inv_mod(value, modulo).
    def self.inv_mod(value, modulo)
      gcd, inv = extended_gcd(value, modulo)
      if gcd != 1
        raise ArgumentError.new("#{value} and #{modulo} are not coprime")
      end
      inv % modulo
    end

    # Simplified AtCoder::Math.pow_mod with support of Int64
    def self.pow_mod(base, exponent, modulo)
      if exponent == 0
        return base.class.zero + 1
      end
      if base == 0
        return base
      end
      b = exponent > 0 ? base : inv_mod(base, modulo)
      e = exponent.abs
      ret = 1_i64
      while e > 0
        if e % 2 == 1
          ret = mul_mod(ret, b, modulo)
        end
        b = mul_mod(b, b, modulo)
        e //= 2
      end
      ret
    end

    # Caluculates a * b % mod without overflow detection
    @[AlwaysInline]
    def self.mul_mod(a : Int64, b : Int64, mod : Int64)
      if mod < Int32::MAX
        return a * b % mod
      end

      # 31-bit width
      a_high = (a >> 32).to_u64
      # 32-bit width
      a_low = (a & 0xFFFFFFFF).to_u64
      # 31-bit width
      b_high = (b >> 32).to_u64
      # 32-bit width
      b_low = (b & 0xFFFFFFFF).to_u64

      # 31-bit + 32-bit + 1-bit = 64-bit
      c = a_high * b_low + b_high * a_low
      c_high = c >> 32
      c_low = c & 0xFFFFFFFF

      # 31-bit + 31-bit
      res_high = a_high * b_high + c_high
      # 32-bit + 32-bit
      res_low = a_low * b_low
      res_low_high = res_low >> 32
      res_low_low = res_low & 0xFFFFFFFF

      # Overflow
      if res_low_high + c_low >= 0x100000000
        res_high += 1
      end

      res_low = (((res_low_high + c_low) & 0xFFFFFFFF) << 32) | res_low_low

      (((res_high.to_i128 << 64) | res_low) % mod).to_i64
    end

    @[AlwaysInline]
    def self.mul_mod(a, b, mod)
      typeof(mod).new(a.to_i64 * b % mod)
    end

    # Implements atcoder::crt(remainders, modulos).
    def self.crt(remainders, modulos)
      raise ArgumentError.new unless remainders.size == modulos.size

      total_modulo = 1_i64
      answer = 0_i64

      remainders.zip(modulos).each do |(remainder, modulo)|
        gcd, p = extended_gcd(total_modulo, modulo)
        if (remainder - answer) % gcd != 0
          return 0_i64, 0_i64
        end
        tmp = (remainder - answer) // gcd * p % (modulo // gcd)
        answer += total_modulo * tmp
        total_modulo *= modulo // gcd
      end

      return answer % total_modulo, total_modulo
    end

    # Implements atcoder::floor_sum(n, m, a, b).
    def self.floor_sum(n, m, a, b)
      n, m, a, b = n.to_i64, m.to_i64, a.to_i64, b.to_i64
      res = 0_i64

      if a < 0
        a2 = a % m
        res -= n * (n - 1) // 2 * ((a2 - a) // m)
        a = a2
      end

      if b < 0
        b2 = b % m
        res -= n * ((b2 - b) // m)
        b = b2
      end

      res + floor_sum_unsigned(n, m, a, b)
    end

    private def self.floor_sum_unsigned(n, m, a, b)
      res = 0_i64

      loop do
        if a >= m
          res += n * (n - 1) // 2 * (a // m)
          a = a % m
        end

        if b >= m
          res += n * (b // m)
          b = b % m
        end

        y_max = a * n + b
        break if y_max < m

        n = y_max // m
        b = y_max % m
        m, a = a, m
      end

      res
    end
  end
end

module AtCoder
  # Implements [atcoder::static_modint](https://atcoder.github.io/ac-library/master/document_en/modint.html).
  #
  # ```
  # AtCoder.static_modint(ModInt101, 101_i64)
  # alias Mint = AtCoder::ModInt101
  # Mint.new(80_i64) + Mint.new(90_i64) # => 89
  # ```
  macro static_modint(name, modulo)
    module AtCoder
      # Implements atcoder::modint{{modulo}}.
      #
      # ```
      # alias Mint = AtCoder::{{name}}
      # Mint.new(30_i64) // Mint.new(7_i64)
      # ```
      record {{name}}, value : Int64 do
        MOD = {{modulo}}

        # Change the initial capacity of this array to improve performance
        @@factorials = Array(self).new(100_000_i64)

        def self.factorial(n)
          if @@factorials.empty?
            @@factorials << self.new(1_i64)
          end
          @@factorials.size.upto(n) do |i|
            @@factorials << @@factorials.last * i
          end
          @@factorials[n]
        end

        def self.permutation(n, k)
          raise ArgumentError.new("k cannot be greater than n") unless n >= k
          factorial(n) // factorial(n - k)
        end

        def self.combination(n, k)
          raise ArgumentError.new("k cannot be greater than n") unless n >= k
          permutation(n, k) // @@factorials[k]
        end

        def self.repeated_combination(n, k)
          combination(n + k - 1, k)
        end

        def self.zero
          self.new(0_i64)
        end

        def inv
          g, x = AtCoder::Math.extended_gcd(@value, MOD)
          self.class.new(x % MOD)
        end

        def +(value)
          self.class.new((@value + value.to_i64 % MOD) % MOD)
        end

        def -(value)
          self.class.new((@value + MOD - value.to_i64 % MOD) % MOD)
        end

        def *(value)
          self.class.new((@value * value.to_i64 % MOD) % MOD)
        end

        def /(value : self)
          raise DivisionByZeroError.new if value == 0
          self * value.inv
        end

        def /(value)
          raise DivisionByZeroError.new if value == 0
          self * self.class.new(value.to_i64 % MOD).inv
        end

        def //(value)
          self./(value)
        end

        def **(value)
          self.class.new(AtCoder::Math.pow_mod(@value, value.to_i64, MOD))
        end

        def <<(value)
          self * self.class.new(2_i64) ** value
        end

        def sqrt
          z = self.class.new(1_i64)
          until z ** ((MOD - 1) // 2) == MOD - 1
            z += 1
          end
          q = MOD - 1
          m = 0
          while q % 2 == 0
            q //= 2
            m += 1
          end
          c = z ** q
          t = self ** q
          r = self ** ((q + 1) // 2)
          m.downto(2) do |i|
            tmp = t ** (2 ** (i - 2))
            if tmp != 1
              r *= c
              t *= c ** 2
            end
            c *= c
          end
          if r * r == self
            r.to_i64 * 2 <= MOD ? r : -r
          else
            nil
          end
        end

        def to_i64
          @value
        end

        def ==(value : self)
          @value == value.to_i64
        end

        def ==(value)
          @value == value
        end

        def -
          self.class.new(0_i64) - self
        end

        def +
          self
        end

        def abs
          self
        end

        # ac-library compatibility

        def pow(value)
          self.**(value)
        end
        def val
          self.to_i64
        end

        # ModInt shouldn't be compared

        def <(value)
          raise NotImplementedError.new("<")
        end
        def <=(value)
          raise NotImplementedError.new("<=")
        end
        def >(value)
          raise NotImplementedError.new(">")
        end
        def >=(value)
          raise NotImplementedError.new(">=")
        end

        delegate to_s, to: @value
        delegate inspect, to: @value
      end
    end

    struct Int
      def +(value : AtCoder::{{name}})
        value + self
      end

      def -(value : AtCoder::{{name}})
        -value + self
      end

      def *(value : AtCoder::{{name}})
        value * self
      end

      def //(value : AtCoder::{{name}})
        value.inv * self
      end

      def /(value : AtCoder::{{name}})
        self // value
      end

      def ==(value : AtCoder::{{name}})
        value == self
      end
    end
  end
end

AtCoder.static_modint(ModInt1000000007, 1_000_000_007_i64)
AtCoder.static_modint(ModInt998244353, 998_244_353_i64)

n, k = read_line.split.map(&.to_i64)
k = AtCoder::ModInt1000000007.new k
ans = k
ans *= k - 1 if n >= 2
ans *= (k - 2)**(n - 2) if n >= 3
puts ans
