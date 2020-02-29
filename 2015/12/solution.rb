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
    solve_b(File.read('input'))
  end

  private

  def sum(obj, cond: ->(_) { false })
    case obj
    when Integer
      obj
    when Array
      obj.map { |v| sum(v, cond: cond) }.sum
    when Hash
      return 0 if cond.call(obj)

      obj.map { |_k, v| sum(v, cond: cond) }.sum
    else
      0
    end
  end

  def solve_a(input)
    sum(JSON.parse(input))
  end

  def solve_b(input)
    sum(JSON.parse(input), cond: ->(h) { h.any? { |_k, v| v == 'red' } })
  end
end
