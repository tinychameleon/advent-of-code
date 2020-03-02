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
    :ok
  end

  def part_a
    solve_a(File.read('input'))
  end

  def part_b
    raise NotImplementedError
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

  def solve_a(input)
    distinct_molecules(parse_molecular_data(input))
  end

  def solve_b(_input)
    raise NotImplementedError
  end
end
