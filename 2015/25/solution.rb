require './utils'

class Solution
  def tests
    assert read_coordinates('embedded row 123, column 42 coords'), [123, 42]
    assert code_number(1, 5), 15
    assert code_number(1, 1), 1
    assert code_number(4, 2), 12
    assert code(1), 20_151_125
    assert code(4), 16_080_970
    :ok
  end

  def part_a
    solve_a(File.read('input'))
  end

  def part_b
    raise NotImplementedError
  end

  private

  SEED = 20_151_125
  BASE = 252_533
  DIVISOR = 33_554_393

  def read_coordinates(input)
    input.scan(/\d+/).map(&:to_i)
  end

  def code_number(row, col)
    n = row + col - 2
    n * (n + 1) / 2 + col
  end

  def code(num)
    (1...num).reduce(SEED) { |code, _| code * BASE % DIVISOR }
  end

  def solve_a(input)
    code(code_number(*read_coordinates(input)))
  end

  def solve_b(_input)
    raise NotImplementedError
  end
end
