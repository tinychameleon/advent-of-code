require './utils'

class Solution
  def tests
    assert nice?('ugknbfddgicrmopn'), true
    assert nice?('aaa'), true
    assert nice?('jchzalrnumimnmhp'), false
    assert nice?('haegwjzuvuyypxyu'), false
    assert nice?('dvszwmarrgswjxmb'), false
    :ok
  end

  def part_a
    solve_a(File.read('input'))
  end

  def part_b
    raise NotImplementedError
  end

  private

  def nice?(word)
    [
      word.scan(/[aeiou]/).count >= 3,
      word.match?(/([a-z])\1/),
      !word.match(/ab|cd|pq|xy/)
    ].all?
  end

  def solve_a(input)
    input.split.filter { |w| nice?(w) }.count
  end

  def solve_b(input)
    raise NotImplementedError
  end
end
