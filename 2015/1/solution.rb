require './utils'

class Solution
  def tests
    assert solve_a('(())'), 0
    assert solve_a('()()'), 0
    assert solve_a('((('), 3
    assert solve_a('(()(()('), 3
    assert solve_a('))((((('), 3
    assert solve_a('())'), -1
    assert solve_a('))('), -1
    assert solve_a(')))'), -3
    assert solve_a(')())())'), -3

    assert solve_b(')'), 1
    assert solve_b('()())'), 5
    assert solve_b('(()))(('), 5
    :ok
  end

  def part_a
    solve_a(File.read('input'))
  end

  def part_b
    solve_b(File.read('input'))
  end

  private

  def solve_a(input)
    input.each_char.reduce(0) do |floor, c|
      floor += c == '(' ? 1 : -1
    end
  end

  def solve_b(input)
    floor = 0
    input.each_char.with_index(1) do |c, pos|
      floor += c == '(' ? 1 : -1
      return pos if floor == -1
    end
  end
end
