require './utils'

class Solution
  TEST_INPUT = <<~DATA.freeze
    20
    15
    10
    5
    5
  DATA

  TEST_DATA = [20, 15, 10, 5, 5].freeze

  def tests
    assert parse_containers(TEST_INPUT), TEST_DATA
    assert minimum_containers(TEST_DATA, 25), 2
    assert storage_ways(TEST_DATA, 2, 25), 3
    assert all_storage_ways(TEST_DATA, 25), 4
    :ok
  end

  def part_a
    solve_a(File.read('input'))
  end

  def part_b
    solve_b(File.read('input'))
  end

  private

  def parse_containers(input)
    input.lines.map(&:to_i)
  end

  def storage_ways(containers, choose, amount)
    containers.combination(choose).count { |c| c.sum == amount }
  end

  def minimum_containers(containers, amount)
    (1..containers.size).each do |s|
      return s if containers.combination(s).any? { |c| c.sum == amount }
    end
  end

  def all_storage_ways(containers, amount)
    (1..containers.size).map { |s| storage_ways(containers, s, amount) }.sum
  end

  def solve_a(input)
    all_storage_ways(parse_containers(input), 150)
  end

  def solve_b(input)
    containers = parse_containers(input)
    storage_ways(containers, minimum_containers(containers, 150), 150)
  end
end
