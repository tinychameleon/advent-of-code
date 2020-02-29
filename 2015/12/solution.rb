require './utils'
require 'json'

class Solution
  def tests
    assert sum([1, 2, 3]), 6
    assert sum({ "a": 2, "b": 4 }), 6
    assert sum([[[3]]]), 3
    assert sum({ "a": { "b": 4 }, "c": -1 }), 3
    assert sum({ "a": [-1, 1] }), 0
    assert sum([-1, { "a": 1 }]), 0
    assert sum([]), 0
    assert sum({}), 0
    :ok
  end

  def part_a
    solve_a(File.read('input'))
  end

  def part_b
    raise NotImplementedError
  end

  private

  def sum(obj)
    case obj
    when Integer
      obj
    when Array
      obj.map { |v| sum(v) }.sum
    when Hash
      obj.values.map { |v| sum(v) }.sum
    else
      0
    end
  end

  def solve_a(input)
    sum(JSON.parse(input))
  end

  def solve_b(input)
    raise NotImplementedError
  end
end
