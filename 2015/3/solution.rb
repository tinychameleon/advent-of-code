require './utils'
require 'set'

class Solution
  def tests
    assert santa_tracker('>'), { 0 => Set[0], 1 => Set[0] }
    assert santa_tracker('^>v<'), { 0 => Set[0, 1], 1 => Set[1, 0] }
    assert santa_tracker('^v^v^v^v^v'), { 0 => Set[0, 1] }

    assert solve_a('>'), 2
    assert solve_a('^>v<'), 4
    assert solve_a('^v^v^v^v^v'), 2
    :ok
  end

  def part_a
    solve_a(File.read('input'))
  end

  def part_b
    raise NotImplementedError
  end

  private

  Point = Struct.new(:x, :y) do
    def add(other)
      self.x += other.x
      self.y += other.y
    end
  end

  DELTAS = {
    '>' => Point.new(1, 0),
    '<' => Point.new(-1, 0),
    '^' => Point.new(0, 1),
    'v' => Point.new(0, -1)
  }.freeze

  def new_house_map
    map = Hash.new { |h, k| h[k] = Set.new }
    map[0].add(0)
    map
  end

  def santa_tracker(directions)
    houses = new_house_map
    pos = Point.new(0, 0)
    directions.each_char do |c|
      pos.add(DELTAS[c])
      houses[pos.x].add(pos.y)
    end
    houses
  end

  def solve_a(input)
    santa_tracker(input).values.map(&:count).sum
  end

  def solve_b(input)
    raise NotImplementedError
  end
end
