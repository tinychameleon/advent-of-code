require './utils'

class Solution
  TEST_INPUT = <<~DATA.freeze
    20
    15
    10
    5
    5
  DATA

  def tests
    assert parse_containers(TEST_INPUT), [20, 15, 10, 5, 5]
    assert storage_ways([20, 15, 10, 5, 5], 25), 4
    :ok
  end

  def part_a
    solve_a(File.read('input'))
  end

  def part_b
    raise NotImplementedError
  end

  private

  def parse_containers(input)
    input.lines.map(&:to_i)
  end

  def storage_ways(containers, amount)
    (1..containers.size).map do |s|
      containers.combination(s).count { |c| c.sum == amount }
    end.sum
  end

  def solve_a(input)
    storage_ways(parse_containers(input), 150)
  end

  def solve_b(_input)
    raise NotImplementedError
  end
end
