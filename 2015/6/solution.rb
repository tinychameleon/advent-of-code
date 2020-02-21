require './utils'

Point = Struct.new(:x, :y)

class LightGrid
  def initialize(rows: 1_000, cols: 1_000)
    @grid = [false] * rows * cols
    @cols = cols
  end

  def count
    @grid.filter(&:itself).count
  end

  def turn_on(origin, bound)
    change_state(origin, bound) { true }
  end

  def turn_off(origin, bound)
    change_state(origin, bound) { false }
  end

  def toggle(origin, bound)
    change_state(origin, bound) { |b| !b }
  end

  private

  def change_state(origin, bound)
    for y in origin.y..bound.y
      offset = @cols * y
      for x in origin.x..bound.x
        @grid[offset + x] = yield @grid[offset + x]
      end
    end
  end
end

class Solution
  def tests
    test_lightgrid
    test_parse_line
    test_solve_a
    :ok
  end

  def part_a
    solve_a(LightGrid.new, File.read('input'))
  end

  def part_b
    raise NotImplementedError
  end

  private

  def test_lightgrid
    g = LightGrid.new(rows: 2, cols: 2)
    #   0 1
    # 0 - -
    # 1 - -
    assert g.count, 0

    #   0 1
    # 0 + -
    # 1 + -
    g.turn_on(Point.new(0, 0), Point.new(0, 1))
    assert g.count, 2

    #   0 1
    # 0 + -
    # 1 - -
    g.turn_off(Point.new(0, 1), Point.new(1, 1))
    assert g.count, 1

    #   0 1
    # 0 - +
    # 1 + +
    g.toggle(Point.new(0, 0), Point.new(1, 1))
    assert g.count, 3
  end

  def test_parse_line
    assert parse_line('turn on 0,0 through 999,999'), [
      :on, Point.new(0, 0), Point.new(999, 999)
    ]
    assert parse_line('toggle 0,0 through 999,0'), [
      :toggle, Point.new(0, 0), Point.new(999, 0)
    ]
    assert parse_line('turn off 499,499 through 500,500'), [
      :off, Point.new(499, 499), Point.new(500, 500)
    ]
  end

  def test_solve_a
    g = LightGrid.new(rows: 2, cols: 2)
    input = <<~data
      turn on 0,0 through 0,1
      turn off 0,1 through 1,1
      toggle 0,0 through 1,1
    data
    assert solve_a(g, input), 3
  end

  MATCHERS = {
    on: /turn on (\d+),(\d+) through (\d+),(\d+)/,
    off: /turn off (\d+),(\d+) through (\d+),(\d+)/,
    toggle: /toggle (\d+),(\d+) through (\d+),(\d+)/
  }.freeze

  def parse_line(line)
    MATCHERS.each do |k, re|
      m = line.match(re)
      next unless m
      ps = make_points(m.captures)
      return ps.prepend(k)
    end
  end

  def make_points(captures)
    ps = captures.map(&:to_i)
    [Point.new(ps[0], ps[1]), Point.new(ps[2], ps[3])]
  end

  def solve_a(grid, input)
    input.split("\n").map { |l| parse_line(l) }.each do |action, origin, bound|
      case action
      when :on
        grid.turn_on(origin, bound)
      when :off
        grid.turn_off(origin, bound)
      when :toggle
        grid.toggle(origin, bound)
      end
    end
    grid.count
  end

  def solve_b(input)
    raise NotImplementedError
  end
end

