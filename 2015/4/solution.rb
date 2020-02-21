require './utils'
require 'digest'

class Solution
  def tests
    assert solve('abcdef'), 609_043
    :ok
  end

  INPUT = 'bgvyzdsv'.freeze

  def part_a
    solve(INPUT)
  end

  def part_b
    raise NotImplementedError
  end

  private

  def solve(input)
    prefix = '0' * 5
    (1..).each do |i|
      hex = Digest::MD5.hexdigest "#{input}#{i}"
      return i if hex.start_with? prefix
    end
  end
end
