require './utils'

class Solution
  TEST_INPUT = <<~DATA.freeze
    Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8
    Cinnamon: capacity 2, durability 3, flavor -2, texture -1, calories 3
  DATA

  TEST_DATA = [
    [-1, -2, 6, 3],
    [2, 3, -2, -1]
  ].freeze

  def tests
    assert parse_ingredients(TEST_INPUT, max_traits: 4), TEST_DATA
    assert calculate_score(TEST_DATA, [44, 56]), 62_842_880
    assert combinations(sum: 4, terms: 1).to_a, [[4]]
    assert combinations(sum: 4, terms: 3).to_a, [
      [0, 0, 4], [0, 1, 3], [0, 2, 2], [0, 3, 1], [0, 4, 0],
      [1, 0, 3], [1, 1, 2], [1, 2, 1], [1, 3, 0], [2, 0, 2],
      [2, 1, 1], [2, 2, 0], [3, 0, 1], [3, 1, 0], [4, 0, 0]
    ]
    assert max_score(TEST_DATA), 62_842_880
    :ok
  end

  def part_a
    solve_a(File.read('input'))
  end

  def part_b
    raise NotImplementedError
  end

  private

  def parse_ingredients(input, max_traits:)
    input.lines.each_with_object([]) do |line, ingredients|
      _, traits = line.split(':')
      ingredients << traits.scan(/-?\d+/).map(&:to_i)[0...max_traits]
    end
  end

  def calculate_score(ingredients, amounts)
    scores = ingredients.zip(amounts).map do |traits, amount|
      traits.map { |v| v * amount }
    end
    scores[0].zip(*scores[1..]).map { |xs| [0, xs.sum].max }.reduce(1, &:*)
  end

  def combinations(sum:, terms:)
    return [[sum]].to_enum if terms == 1

    Enumerator.new do |yielder|
      (0..sum).each do |i|
        prefix = [i]
        combinations(sum: sum - i, terms: terms - 1).each do |combo|
          yielder << prefix + combo
        end
      end
    end
  end

  def max_score(ingredients)
    combinations(sum: 100, terms: ingredients.size).map do |combo|
      calculate_score(ingredients, combo)
    end.max
  end

  def solve_a(input)
    max_score(parse_ingredients(input, max_traits: 4))
  end

  def solve_b(_input)
    raise NotImplementedError
  end
end
