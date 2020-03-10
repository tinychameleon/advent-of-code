require './utils'

class Array
  def mul
    reduce(1, &:*)
  end

  def combinations_with_sum(size, sum)
    combination(size).lazy.filter { |c| c.sum == sum }
  end
end

class Solution
  def tests
    assert read_package_weights("1\n2\n3\n"), [1, 2, 3]

    assert [*1..8].combinations_with_sum(2, 12).to_a, [[4, 8], [5, 7]]
    assert [*1..8].combinations_with_sum(3, 12).to_a, [
      [1, 3, 8], [1, 4, 7], [1, 5, 6], [2, 3, 7], [2, 4, 6], [3, 4, 5]
    ]

    assert entanglement([*1..8], 3).to_a, [32, 35, 24, 30, 42, 48, 36]

    :ok
  end

  def part_a
    solve_a(File.read('input'))
  end

  def part_b
    raise NotImplementedError
  end

  private

  def read_package_weights(input)
    input.lines.map(&:to_i)
  end

  def entanglement(arr, num_groups)
    return [arr.mul] if num_groups == 1

    target = arr.sum / num_groups
    (1..arr.size - num_groups).lazy.flat_map do |size|
      arr.combinations_with_sum(size, target)
         .reject { |c| entanglement(arr - c, num_groups - 1).first.nil? }
         .map(&:mul)
    end
  end

  def solve_a(input)
    entanglement(read_package_weights(input), 3).first
  end

  def solve_b(_input)
    raise NotImplementedError
  end
end
