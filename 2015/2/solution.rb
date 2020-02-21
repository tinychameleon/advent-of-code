require './utils'

class Solution
  def tests
    assert necessary_paper('2x3x4'), 58
    assert necessary_paper('1x1x10'), 43
    assert necessary_paper('1x1x1'), 7

    assert solve_a("2x3x4\n1x1x1"), 65

    assert necessary_ribbon('2x3x4'), 34
    assert necessary_ribbon('1x1x10'), 14
    assert necessary_ribbon('1x1x1'), 5

    assert solve_b("2x3x4\n1x1x1"), 39
    :ok
  end

  def part_a
    solve_a(File.read('input'))
  end

  def part_b
    solve_b(File.read('input'))
  end

  private

  Box = Struct.new(:l, :w, :h) do
    def self.from(str)
      Box.new(*str.split('x').map(&:to_i))
    end

    def areas
      [l * w, l * h, w * h]
    end

    def volume
      l * w * h
    end

    def perimeters
      ll = l + l
      ww = w + w
      hh = h + h
      [ll + ww, ll + hh, ww + hh]
    end
  end

  def necessary_paper(dimensions)
    b = Box.from(dimensions)
    b.areas.min + b.areas.sum * 2
  end

  def necessary_ribbon(dimensions)
    b = Box.from(dimensions)
    b.perimeters.min + b.volume
  end

  def solve_a(input)
    input.split.map { |d| necessary_paper(d) }.sum
  end

  def solve_b(input)
    input.split.map { |d| necessary_ribbon(d) }.sum
  end
end
