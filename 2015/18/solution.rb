require './utils'

class Grid
  attr_reader :lights

  def initialize(rows, cols, input)
    @rows = 0...rows
    @cols = 0...cols
    @memo = {}
    @lights = input.each_char.map { |c| c == '.' ? :off : :on }
  end

  def step
    @lights = @lights.map.with_index do |state, i|
      y = i / @cols.end
      x = i % @cols.end
      transition(state, neighbour_states(x, y).count(:on))
    end
  end

  def lights_on
    @lights.count(:on)
  end

  private

  DELTAS = [
    [1, 0], [1, 1], [0, 1], [-1, 1], [-1, 0], [-1, -1], [0, -1], [1, -1]
  ].freeze

  def neighbour_states(x, y)
    k = [x, y]
    unless @memo.key?(k)
      @memo[k] = DELTAS.map { |dx, dy| [dx + x, dy + y] }.filter do |nx, ny|
        @cols.member?(nx) && @rows.member?(ny)
      end
    end
    @memo[k].map { |nx, ny| @lights[nx + ny * @cols.end] }
  end

  def transition(state, neighbouring_ons)
    return :off if state == :on && !(2..3).include?(neighbouring_ons)
    return :on if state == :off && neighbouring_ons == 3

    state
  end
end

class Solution
  TEST_INPUT = <<~DATA.freeze
    .#.#.#
    ...##.
    #....#
    ..#...
    #.#..#
    ####..
  DATA

  def tests
    assert load_grid(".#\n..\n"), '.#..'
    g = Grid.new(6, 6, load_grid(TEST_INPUT))
    assert g.lights_on, 15
    4.times { g.step }
    assert g.lights_on, 4
    :ok
  end

  def part_a
    solve_a(File.read('input'))
  end

  def part_b
    raise NotImplementedError
  end

  private

  def load_grid(input)
    input.lines.map(&:chomp).join
  end

  def solve_a(input)
    g = Grid.new(100, 100, load_grid(input))
    100.times { g.step }
    g.lights_on
  end

  def solve_b(_input)
    raise NotImplementedError
  end
end
