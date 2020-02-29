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
    solve(INPUT, 40)
  end

  def part_b
    solve(INPUT, 50)
  end

  private

  def look_and_say(number)
    result = ''
    i = 0
    while i < number.length
      c = number[i]
      j = i
      j += 1 while j < number.length && number[j] == c
      result << "#{j - i}#{c}"
      i = j
    end
    result
  end

  def solve(input, iterations)
    iterations.times { input = look_and_say(input) }
    input.length
  end
end
