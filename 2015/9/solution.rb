require './utils'

class Solution
  TEST_INPUT = <<~DATA
    London to Dublin = 464
    London to Belfast = 518
    Dublin to Belfast = 141
  DATA

  def tests
    distances = parse_distances(TEST_INPUT)
    assert distances, {
      ['Belfast', 'London'] => 518,
      ['Belfast', 'Dublin'] => 141,
      ['Dublin', 'London'] => 464
    }
    assert shortest_path(distances), 605
    :ok
  end

  def part_a
    solve_a(File.read('input'))
  end

  def part_b
    raise NotImplementedError
  end

  private

  def parse_distances(input)
    input.split.each_slice(5).each_with_object({}) do |line, atlas|
      origin, _to, destination, _eq, distance = line
      atlas[[origin, destination].sort] = distance.to_i
    end
  end

  def shortest_path(distances)
    cities = distances.keys.flatten.uniq
    cities.permutation.map do |ordering|
      ordering.each_cons(2).reduce(0) { |sum, k| sum + distances[k.sort] }
    end.min
  end

  def solve_a(input)
    distances = parse_distances(input)
    shortest_path(distances)
  end

  def solve_b(_input)
    raise NotImplementedError
  end
end
