require './utils'

class Solution
  INPUT = '1113222113'.freeze

  def tests
    assert look_and_say('1'), '11'
    assert look_and_say('11'), '21'
    assert look_and_say('21'), '1211'
    assert look_and_say('1211'), '111221'
    assert look_and_say('111221'), '312211'
    :ok
  end

  def part_a
    solve_a(INPUT)
  end

  def part_b
    raise NotImplementedError
  end

  private

  def look_and_say(number)
    result = ''
    until (m = /(\d)\1*/.match(number)).nil?
      result << "#{m[0].length}#{m[1]}"
      number = m.post_match
    end
    result
  end

  def solve_a(input)
    40.times { input = look_and_say(input) }
    input.length
  end

  def solve_b(_input)
    raise NotImplementedError
  end
end
