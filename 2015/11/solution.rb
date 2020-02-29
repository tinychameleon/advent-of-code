require './utils'

class Solution
  INPUT = 'vzbxkghb'.freeze

  def tests
    assert valid('hijklmmn'), false
    assert valid('abbceffg'), false
    assert valid('abbcdegk'), false
    assert valid('abcdffaa'), true
    assert valid('ghjaabcc'), true
    assert solve('abcdefgh'), 'abcdffaa'
    assert solve('ghijklmn'), 'ghjaabcc'
    :ok
  end

  def part_a
    solve(+INPUT)
  end

  def part_b
    solve(solve(+INPUT).succ!)
  end

  private

  SEQUENCES = Regexp.union(('a'..'z').to_a.each_cons(3).map(&:join)).freeze
  DISALLOWED = /[iol]/.freeze
  DOUBLES = /(.)\1/.freeze

  def valid(s)
    !s[SEQUENCES].nil? && s !~ DISALLOWED && s.scan(DOUBLES).uniq.length > 1
  end

  def solve(input)
    input.succ! until valid(input)
    input
  end
end
