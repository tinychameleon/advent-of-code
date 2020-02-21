require './utils'

class Solution
  def tests
    assert nice?('ugknbfddgicrmopn'), true
    assert nice?('aaa'), true
    assert nice?('jchzalrnumimnmhp'), false
    assert nice?('haegwjzuvuyypxyu'), false
    assert nice?('dvszwmarrgswjxmb'), false

    assert better_nice?('qjhvhtzxzqqjkmpb'), true
    assert better_nice?('xxyxx'), true
    assert better_nice?('aaaya'), false
    assert better_nice?('uurcxstgmygtbstg'), false
    assert better_nice?('ieodomkazucvgmuy'), false
    :ok
  end

  def part_a
    solve_a(File.read('input'))
  end

  def part_b
    solve_b(File.read('input'))
  end

  private

  def nice?(word)
    [
      word.scan(/[aeiou]/).count >= 3,
      word.match?(/([a-z])\1/),
      !word.match(/ab|cd|pq|xy/)
    ].all?
  end

  def better_nice?(word)
    [
      word.match?(/([a-z]{2}).*\1/),
      word.match?(/([a-z])[a-z]\1/)
    ].all?
  end

  def solve_a(input)
    input.split.filter { |w| nice?(w) }.count
  end

  def solve_b(input)
    input.split.filter { |w| better_nice?(w) }.count
  end
end
