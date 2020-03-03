require './utils'

class Solution
  TEST_INPUT = <<~DATA.freeze
    H => HO
    H => OH
    O => HH

    HOHOHO
  DATA

  def tests
    assert parse_molecular_data(TEST_INPUT), {
      replacements: { 'H' => %w[HO OH], 'O' => ['HH'] },
      molecule: 'HOHOHO'
    }
    assert distinct_molecules(parse_molecular_data(TEST_INPUT)), 7

    assert flip(parse_molecular_data(TEST_INPUT)), {
      replacements: { 'HO' => 'H', 'OH' => 'H', 'HH' => 'O' },
      molecule: 'HOHOHO'
    }

    input = File.read('input_b_test')
    assert min_steps(target: 'e', **flip(parse_molecular_data(input))), 6
    :ok
  end

  def part_a
    solve_a(File.read('input'))
  end

  def part_b
    solve_b(File.read('input'))
  end

  private

  def parse_molecular_data(input)
    replacements = Hash.new { |h, k| h[k] = [] }
    *data, molecule = input.split
    data.each_slice(3) { |k, _, v| replacements[k] << v }
    { replacements: replacements, molecule: molecule }
  end

  def scan_replace(str, pattern, replacement)
    str.to_enum(:scan, pattern).map do
      a, b = Regexp.last_match.offset(0)
      s = str.dup
      s[a...b] = replacement
      s
    end
  end

  def distinct_molecules(molecule:, replacements:)
    replacements
      .flat_map { |k, vs| [k].product(vs) }
      .flat_map { |k, v| scan_replace(molecule, k, v) }
      .uniq
      .size
  end

  def flip(molecule:, replacements:)
    r = replacements.flat_map { |k, vs| vs.product([k]) }.to_h
    { replacements: r, molecule: molecule }
  end

  def min_steps(target:, molecule:, replacements:)
    re = replacements.keys.sort_by { |k| -k.size }.map { |k| Regexp.new(k) }
    (0..).each do |i|
      return i if molecule == target

      molecule.sub!(re.each.lazy.filter { |r| molecule[r] }.first, replacements)
    end
  end

  def solve_a(input)
    distinct_molecules(parse_molecular_data(input))
  end

  def solve_b(input)
    min_steps(target: 'e', **flip(parse_molecular_data(input)))
  end
end
