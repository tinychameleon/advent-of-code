require './utils'

class Solution
  def tests
    assert factors(6).sort, [1, 2, 3, 6]
    assert factors(7).sort, [1, 7]
    assert factors(1).sort, [1]
    assert factors(9).sort, [1, 3, 9]

    :ok
  end

  INPUT = 29_000_000

  def part_a
    solve_a(INPUT)
  end

  def part_b
    solve_b(INPUT)
  end

  private

  def factors(n)
    fs = [1, n]
    (2..Math.sqrt(n)).each do |i|
      next if n % i != 0

      fs << i
      fs << n / i
    end
    fs.uniq
  end

  def solve_a(input)
    target = input / 10
    (1..).each do |house|
      return house if target < factors(house).sum
    end
  end

  def solve_b(input)
    target = input / 11
    (665_281..).each do |house|
      return house if target < factors(house).filter { |f| house / f <= 50 }.sum
    end
  end
end
