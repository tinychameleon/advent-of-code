require './utils'
require 'digest'

class Solution
  def tests
    assert solve('abcdef', zeroes: 5), 609_043
    assert solve('pqrstuv', zeroes: 5), 1_048_970
    :ok
  end

  INPUT = 'bgvyzdsv'.freeze

  def part_a
    solve(INPUT, zeroes: 5)
  end

  def part_b
    solve(INPUT, zeroes: 6)
  end

  private

  def solve(input, zeroes:)
    prefix = '0' * zeroes
    (1..).each do |i|
      hex = Digest::MD5.hexdigest "#{input}#{i}"
      return i if hex.start_with? prefix
    end
  end
end
