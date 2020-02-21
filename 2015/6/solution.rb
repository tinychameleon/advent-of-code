require './utils'

Point = Struct.new(:x, :y) do
  def self.[](x, y)
    Point.new(x, y)
  end
end

class Integer
  def max(i)
    self > i ? self : i
  end
end

class LightGrid
  def initialize(val, rows: 1_000, cols: 1_000)
    @grid = [val] * rows * cols
    @cols = cols
  end

  def turn_on(origin, bound)
    raise NotImplementedError
  end

  def turn_off(origin, bound)
    raise NotImplementedError
  end

  def toggle(origin, bound)
    raise NotImplementedError
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

class SwitchLightGrid < LightGrid
  def initialize(rows: 1_000, cols: 1_000)
    super(false, rows: rows, cols: cols)
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
end

class DimmableLightGrid < LightGrid
  def initialize(rows: 1_000, cols: 1_000)
    super(0, rows: rows, cols: cols)
  end

  def brightness
    @grid.sum
  end

  def turn_on(origin, bound)
    change_state(origin, bound) { |i| i + 1 }
  end

  def turn_off(origin, bound)
    change_state(origin, bound) { |i| 0.max(i - 1) }
  end

  def toggle(origin, bound)
    change_state(origin, bound) { |i| i + 2 }
  end
end

class Solution
  def tests
    test_switchlightgrid
    test_parse_line
    test_solve_a

    test_dimmablelightgrid
    test_solve_b
    :ok
  end

  def part_a
    solve_a(SwitchLightGrid.new, File.read('input'))
  end

  def part_b
    solve_b(DimmableLightGrid.new, File.read('input'))
  end

  private

  def test_switchlightgrid
    g = SwitchLightGrid.new(rows: 2, cols: 2)
    #   0 1
    # 0 - -
    # 1 - -
    assert g.count, 0

    #   0 1
    # 0 + -
    # 1 + -
    g.turn_on(Point[0, 0], Point[0, 1])
    assert g.count, 2

    #   0 1
    # 0 + -
    # 1 - -
    g.turn_off(Point[0, 1], Point[1, 1])
    assert g.count, 1

    #   0 1
    # 0 - +
    # 1 + +
    g.toggle(Point[0, 0], Point[1, 1])
    assert g.count, 3
  end

  def test_dimmablelightgrid
    g = DimmableLightGrid.new(rows: 2, cols: 2)
    #   0 1
    # 0 0 0
    # 1 0 0
    assert g.brightness, 0

    #   0 1
    # 0 1 0
    # 1 1 0
    g.turn_on(Point[0, 0], Point[0, 1])
    assert g.brightness, 2

    #   0 1
    # 0 1 0
    # 1 0 0
    g.turn_off(Point[0, 1], Point[1, 1])
    assert g.brightness, 1

    #   0 1
    # 0 3 2
    # 1 2 2
    g.toggle(Point[0, 0], Point[1, 1])
    assert g.brightness, 9
  end

  def test_parse_line
    assert parse_line('turn on 0,0 through 999,999'), [
      :on, Point[0, 0], Point[999, 999]
    ]
    assert parse_line('toggle 0,0 through 999,0'), [
      :toggle, Point[0, 0], Point[999, 0]
    ]
    assert parse_line('turn off 499,499 through 500,500'), [
      :off, Point[499, 499], Point[500, 500]
    ]
  end

  def test_solve_a
    g = SwitchLightGrid.new(rows: 2, cols: 2)
    input = <<~data
      turn on 0,0 through 0,1
      turn off 0,1 through 1,1
      toggle 0,0 through 1,1
    data
    assert solve_a(g, input), 3
  end

  def test_solve_b
    g = DimmableLightGrid.new(rows: 2, cols: 2)
    input = <<~data
      turn on 0,0 through 0,1
      turn off 0,1 through 1,1
      toggle 0,0 through 1,1
    data
    assert solve_b(g, input), 9
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
    [Point[ps[0], ps[1]], Point[ps[2], ps[3]]]
  end

  def solve_worker(grid, input)
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
  end

  def solve_a(grid, input)
    solve_worker(grid, input)
    grid.count
  end

  def solve_b(grid, input)
    solve_worker(grid, input)
    grid.brightness
  end
end
