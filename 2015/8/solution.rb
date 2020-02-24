require './utils'

class Solution
  def tests
    assert char_counts('""'), { literal: 2, memory: 0 }
    assert char_counts('"abc"'), { literal: 5, memory: 3 }
    assert char_counts('"aaa\"aaa"'), { literal: 10, memory: 7 }
    assert char_counts('"\x27"'), { literal: 6, memory: 1 }

    input = <<~'DATA'
      ""
      "abc"
      "aaa\"aaa"
      "\x27"
    DATA
    assert solve_a(input), 12
    :ok
  end

  def part_a
    solve_a(File.read('input'))
  end

  def part_b
    raise NotImplementedError
  end

  private

  def char_counts(string)
    { literal: string.length, memory: char_scan(string[1...-1]) }
  end

  def char_scan(string)
    len = 0
    i = 0
    while i < string.length
      c = string[i]
      i += 1
      len += 1
      next unless c == '\\'

      i += string[i] == 'x' ? 3 : 1
    end
    len
  end

  def solve_a(input)
    lines = input.split("\n")
    totals = lines.each_with_object({ literal: 0, memory: 0 }) do |line, agg|
      char_counts(line).each { |k, v| agg[k] += v }
    end
    totals[:literal] - totals[:memory]
  end

  def solve_b(_input)
    raise NotImplementedError
  end
end
