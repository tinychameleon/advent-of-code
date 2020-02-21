require './utils'

class Solution
  def tests
    assert necessary_paper('2x3x4'), 58
    assert necessary_paper('1x1x10'), 43
    assert necessary_paper('1x1x1'), 7

    assert solve_a("2x3x4\n1x1x1"), 65
    :ok
  end

  def part_a
    solve_a(File.read('input'))
  end

  def part_b
    raise NotImplementedError
  end

  private

  Box = Struct.new(:l, :w, :h) do
    def self.from(str)
      Box.new(*str.split('x').map(&:to_i))
    end

    def areas
      [l * w, l * h, w * h]
    end
  end

  def necessary_paper(dimensions)
    b = Box.from(dimensions)
    b.areas.min + b.areas.sum * 2
  end

  def solve_a(input)
    input.split.map { |d| necessary_paper(d) }.sum
  end

  def solve_b(input)
    raise NotImplementedError
  end
end
