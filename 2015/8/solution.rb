require './utils'

class Solution
  TEST_INPUT = <<~'DATA'.freeze
    ""
    "abc"
    "aaa\"aaa"
    "\x27"
  DATA

  def tests
    test_counts
    test_encodings
    :ok
  end

  def test_counts
    assert char_counts('""'), { literal: 2, memory: 0 }
    assert char_counts('"abc"'), { literal: 5, memory: 3 }
    assert char_counts('"aaa\"aaa"'), { literal: 10, memory: 7 }
    assert char_counts('"\x27"'), { literal: 6, memory: 1 }
    assert solve_a(TEST_INPUT), 12
  end

  def test_encodings
    assert char_encode('""'), 6 # "\"\""
    assert char_encode('"abc"'), 9 # "\"abc\""
    assert char_encode('"aaa\"aaa"'), 16 # "\"aaa\\\"aaa\""
    assert char_encode('"\x27"'), 11 # "\"\\x27\""
    assert solve_b(TEST_INPUT), 19
  end

  def part_a
    solve_a(File.read('input'))
  end

  def part_b
    solve_b(File.read('input'))
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

  def encode_counts(string)
    { literal: string.length, encoded: char_encode(string) }
  end

  ENCODE = ['\\', '"'].freeze

  def char_encode(string)
    string.each_char.reduce(0) do |sum, c|
      sum + (ENCODE.include?(c) ? 2 : 1)
    end + 2
  end

  def solve_a(input)
    lines = input.split("\n")
    totals = lines.each_with_object({ literal: 0, memory: 0 }) do |line, agg|
      char_counts(line).each { |k, v| agg[k] += v }
    end
    totals[:literal] - totals[:memory]
  end

  def solve_b(input)
    lines = input.split("\n")
    totals = lines.each_with_object({ literal: 0, encoded: 0 }) do |line, agg|
      encode_counts(line).each { |k, v| agg[k] += v }
    end
    totals[:encoded] - totals[:literal]
  end
end
