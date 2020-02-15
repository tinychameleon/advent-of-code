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
    :ok
  end

  def part_a
    solve_a(File.read('input'))
  end

  def part_b
    raise NotImplementedError
  end

  private

  def solve_a(input)
    floor = 0
    input.each_char do |c|
      floor += c == '(' ? 1 : -1
    end
    floor
  end

  def solve_b(input)
    raise NotImplementedError
  end
end
