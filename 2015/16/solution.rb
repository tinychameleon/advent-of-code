require './utils'

class Solution
  TEST_INPUT = <<~DATA.freeze
    Sue 1: cars: 9, akitas: 3, goldfish: 3, cats: 4
    Sue 2: akitas: 9, children: 3, samoyeds: 9
  DATA

  TEST_DATA = [
    { sue: 1, cars: 9, akitas: 3, cats: 4, goldfish: 3 },
    { sue: 2, akitas: 9, children: 3, samoyeds: 9 }
  ].freeze

  def tests
    assert parse_sues(TEST_INPUT), TEST_DATA
    assert solve_a(TEST_INPUT, cats: 2, akitas: 9), 2
    assert solve_b(TEST_INPUT, cats: 2, goldfish: 5, akitas: 3), 1
    :ok
  end

  def part_a
    solve_a(File.read('input'), KNOWN_DETAILS)
  end

  def part_b
    solve_b(File.read('input'), KNOWN_DETAILS)
  end

  private

  KNOWN_DETAILS = {
    children: 3,
    cats: 7,
    samoyeds: 2,
    pomeranians: 3,
    akitas: 0,
    vizslas: 0,
    goldfish: 5,
    trees: 3,
    cars: 2,
    perfumes: 1
  }.freeze

  def parse_sues(input)
    input.lines.map { |l| l.scan(/(\w+): (\d+)/) }.map.with_index do |pairs, i|
      pairs.each_with_object({ sue: i + 1 }) do |kv, h|
        detail, value = kv
        h[detail.to_sym] = value.to_i
      end
    end
  end

  def solve(input, knowns, **comparers)
    knowns.reduce(parse_sues(input)) do |sues, kv|
      detail, limit = kv
      pred = comparers.fetch(detail, ->(v, limit) { v == limit })
      sues.filter { |s| s.key?(detail) ? pred.call(s[detail], limit) : true }
    end.first[:sue]
  end

  def solve_a(input, knowns)
    solve(input, knowns)
  end

  def solve_b(input, knowns)
    gt = ->(v, limit) { v > limit }
    lt = ->(v, limit) { v < limit }
    solve(input, knowns, cats: gt, trees: gt, goldfish: lt, pomeranians: lt)
  end
end
