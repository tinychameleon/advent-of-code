require './utils'

class Solution
  TEST_INPUT = <<~DATA.freeze
    Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.
  DATA

  TEST_DATA = { velocity: 14, duration: 10, resting: 127 }.freeze

  SECONDS = 2503

  def tests
    assert parse_line(TEST_INPUT), TEST_DATA
    assert distance(TEST_DATA, 1), 14
    assert distance(TEST_DATA, 10), 140
    assert distance(TEST_DATA, 11), 140
    assert distance(TEST_DATA, 138), 154
    assert distance(TEST_DATA, 1000), 1120

    assert simulate(TEST_DATA, 10).last, 140
    assert simulate(TEST_DATA, 138).last, 154
    assert simulate(TEST_DATA, 1000).last, 1120
    :ok
  end

  def part_a
    solve_a(File.read('input'), SECONDS)
  end

  def part_b
    solve_b(File.read('input'), SECONDS)
  end

  private

  def parse_line(line)
    v, d, r = line.scan(/\d+/).map(&:to_i)
    { velocity: v, duration: d, resting: r }
  end

  def distance(reindeer, seconds)
    timespan = reindeer[:duration] + reindeer[:resting]
    cycles = seconds / timespan
    remainder = [reindeer[:duration], seconds % timespan].min
    reindeer[:velocity] * (cycles * reindeer[:duration] + remainder)
  end

  def simulate(reindeer, seconds)
    (1..seconds).map { |s| distance(reindeer, s) }
  end

  def solve_a(input, seconds)
    input.lines.map { |l| parse_line(l) }.map { |r| distance(r, seconds) }.max
  end

  def solve_b(input, seconds)
    reindeer = input.lines.map { |l| simulate(parse_line(l), seconds) }
    (0...seconds).each do |i|
      leader = reindeer.map { |km| km[i] }.max
      reindeer.each { |km| km[i] = km[i] == leader ? 1 : 0 }
    end
    reindeer.map(&:sum).max
  end
end
