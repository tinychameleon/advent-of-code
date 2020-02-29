require './utils'

class Solution
  TEST_INPUT = <<~DATA.freeze
    London to Dublin = 464
    London to Belfast = 518
    Dublin to Belfast = 141
  DATA

  def tests
    distances = parse_distances(TEST_INPUT)
    assert distances, {
      'London' => { 'Belfast' => 518, 'Dublin' => 464 },
      'Belfast' => { 'London' => 518, 'Dublin' => 141 },
      'Dublin' => { 'Belfast' => 141, 'London' => 464 }
    }
    assert shortest_path(distances), 605
    assert longest_path(distances), 982
    :ok
  end

  def part_a
    solve_a(File.read('input'))
  end

  def part_b
    solve_b(File.read('input'))
  end

  private

  def parse_distances(input)
    atlas = Hash.new { |h, k| h[k] = {} }
    input.split.each_slice(5) do |origin, _to, destination, _eq, distance|
      d = distance.to_i
      atlas[origin][destination] = d
      atlas[destination][origin] = d
    end
    atlas
  end

  def shortest_path(distances)
    distances.keys.permutation.reduce(Float::INFINITY) do |answer, ordering|
      ordering.each_cons(2).reduce(0) do |sum, k|
        sum += distances.dig(*k)
        break answer if sum > answer

        sum
      end
    end
  end

  def longest_path(distances)
    distances.keys.permutation.reduce(0) do |answer, ordering|
      sum = ordering.each_cons(2).reduce(0) { |sum, k| sum + distances.dig(*k) }
      sum > answer ? sum : answer
    end
  end

  def solve_a(input)
    distances = parse_distances(input)
    shortest_path(distances)
  end

  def solve_b(input)
    distances = parse_distances(input)
    longest_path(distances)
  end
end
