require './utils'

class Solution
  def tests
    test_parse_line
    test_circuit
    test_solve_a
    :ok
  end

  def part_a
    solve_a(File.read('input'), :a)
  end

  def part_b
    raise NotImplementedError
  end

  private

  def test_parse_line
    assert parse_line('123 -> x'), [:x, :val, UInt16.new(123)]
    assert parse_line('x AND y -> z'), %i[z and x y]
    assert parse_line('x OR y -> z'), %i[z or x y]
    assert parse_line('p LSHIFT 2 -> q'), [:q, :lshift, :p, UInt16.new(2)]
    assert parse_line('qg RSHIFT 4 -> td'), [:td, :rshift, :qg, UInt16.new(4)]
    assert parse_line('NOT e -> f'), %i[f not e]
  end

  def test_circuit
    c = Circuit.new
    c << %i[z and x y]
    c << [:x, :val, UInt16.new(123)]
    c << %i[w not z]
    c << [:y, :val, UInt16.new(456)]

    assert c.read(:x), 123
    assert c.read(:z), 72
    assert c.read(:w), 65_463
  end

  TEST_INPUT = <<~DATA.freeze
    123 -> x
    456 -> y
    x AND y -> d
    x OR y -> e
    x LSHIFT 2 -> f
    y RSHIFT 2 -> g
    NOT x -> h
    NOT y -> i
  DATA

  def test_solve_a
    assert solve_a(TEST_INPUT, :g), 114
    assert solve_a(TEST_INPUT, :i), 65_079
  end

  UInt16 = Struct.new(:i) do
    def to_i
      i
    end

    def &(other)
      UInt16.new((i & other.i) & 0xffff)
    end

    def |(other)
      UInt16.new((i | other.i) & 0xffff)
    end

    def <<(other)
      UInt16.new((i << other.i) & 0xffff)
    end

    def >>(other)
      UInt16.new((i >> other.i) & 0xffff)
    end

    def ~
      UInt16.new(~i & 0xffff)
    end
  end

  class Circuit
    def initialize
      @wires = {}
      @signals = {}
    end

    def <<(signal)
      @wires[signal[0]] = signal[1..]
    end

    def read(wire)
      queue = [wire]
      until queue.empty?
        w = queue[-1]
        unless @signals.key?(w)
          gate = @wires[w]
          missing = missing_signals(gate)
          unless missing.empty?
            queue.concat(missing)
            next
          end
          calculate_signal(w, gate)
        end
        queue.pop
      end
      @signals[wire].to_i
    end

    private

    def missing_signals(gate)
      gate[1..].filter { |x| x.is_a?(Symbol) && !@signals.key?(x) }
    end

    def signal(s)
      s.is_a?(Symbol) ? @signals[s] : s
    end

    def calculate_signal(wire, gate)
      s = case gate.length
          when 2
            s = signal(gate[1])
            gate[0] == :not ? ~s : s
          else
            l = signal(gate[1])
            r = signal(gate[2])
            case gate[0]
            when :and
              l & r
            when :or
              l | r
            when :lshift
              l << r
            when :rshift
              l >> r
            end
          end
      @signals[wire] = s
    end
  end

  def value(v)
    /^[0-9]/.match?(v) ? UInt16.new(v.to_i) : v.to_sym
  end

  def components(line)
    gate, wire = line.split(' -> ')
    [wire, gate.split]
  end

  def parse_line(line)
    wire, parts = components(line)
    [wire.to_sym] + case parts.length
                    when 1
                      [:val, value(parts[0])]
                    when 2
                      [:not, value(parts[1])]
                    when 3
                      op = parts[1].downcase.to_sym
                      [op, value(parts[0]), value(parts[2])]
                    end
  end

  def solve_a(input, wire)
    c = Circuit.new
    input.split("\n").each { |l| c << parse_line(l) }
    c.read(wire)
  end

  def solve_b(input)
    raise NotImplementedError
  end
end
