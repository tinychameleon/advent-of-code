require './utils'

class Solution
  INPUT = 'vzbxkghb'.freeze

  def tests
    assert valid('hijklmmn'), false
    assert valid('abbceffg'), false
    assert valid('abbcdegk'), false
    assert valid('abcdffaa'), true
    assert valid('ghjaabcc'), true
    assert solve_a('abcdefgh'), 'abcdffaa'
    assert solve_a('ghijklmn'), 'ghjaabcc'
    :ok
  end

  def part_a
    solve_a(+INPUT)
  end

  def part_b
    raise NotImplementedError
  end

  private

  SEQUENCES = Regexp.union((?a..?z).to_a.each_cons(3).map(&:join))
  DISALLOWED = /[iol]/
  DOUBLES = /(.)\1/

  def valid(s)
    !!s[SEQUENCES] && s !~ DISALLOWED && s.scan(DOUBLES).uniq.length > 1
  end

  def solve_a(input)
    input.succ! until valid(input)
    input
  end

  def solve_b(_input)
    raise NotImplementedError
  end
end
