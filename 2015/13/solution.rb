require './utils'
require 'set'

class Solution
  TEST_INPUT = <<~DATA.freeze
    Alice would gain 54 happiness units by sitting next to Bob.
    Alice would lose 79 happiness units by sitting next to Carol.
    Alice would lose 2 happiness units by sitting next to David.
    Bob would gain 83 happiness units by sitting next to Alice.
    Bob would lose 7 happiness units by sitting next to Carol.
    Bob would lose 63 happiness units by sitting next to David.
    Carol would lose 62 happiness units by sitting next to Alice.
    Carol would gain 60 happiness units by sitting next to Bob.
    Carol would gain 55 happiness units by sitting next to David.
    David would gain 46 happiness units by sitting next to Alice.
    David would lose 7 happiness units by sitting next to Bob.
    David would gain 41 happiness units by sitting next to Carol.
  DATA

  def tests
    assert parse_line(
      'Alice would gain 54 happiness units by sitting next to Bob.'
    ), [%w[Alice Bob], 54]
    assert parse_line(
      'Alice would lose 79 happiness units by sitting next to Carol.'
    ), [%w[Alice Carol], -79]
    assert parse_graph(TEST_INPUT), {
      %w[Alice Bob] => 83 + 54,
      %w[Alice Carol] => -79 + -62,
      %w[Alice David] => -2 + 46,
      %w[Bob Carol] => -7 + 60,
      %w[Bob David] => -63 + -7,
      %w[Carol David] => 55 + 41
    }
    assert seating_happiness(parse_graph(TEST_INPUT)), 330
    :ok
  end

  def part_a
    solve(File.read('input'))
  end

  def part_b
    solve(File.read('input_b'))
  end

  private

  def parse_line(line)
    from, _, sign, delta, *rest = line.split
    to = rest[-1][0..-2]
    [[from, to], (sign == 'gain' ? 1 : -1) * delta.to_i]
  end

  def parse_graph(input)
    input.lines.each_with_object(Hash.new { |h, k| h[k] = 0 }) do |line, graph|
      key, delta = parse_line(line)
      graph[key.sort] += delta
      graph
    end
  end

  def seating_happiness(graph)
    friends = graph.keys.flatten.uniq.sort
    origin = friends.first
    friends[1..].permutation.map do |ordering|
      graph[[origin, ordering.last]] +
        graph[[origin, ordering.first]] +
        ordering.each_cons(2).map { |a, b| graph[[a, b].sort] }.sum
    end.max
  end

  def solve(input)
    seating_happiness(parse_graph(input))
  end
end
