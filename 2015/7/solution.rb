require './utils'

class Solution
  def tests
    test_build_gate
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

  def test_build_gate
    g = build_gate(['123'])
    assert g.inputs, [123]

    g = build_gate(%w[x AND y])
    assert g.inputs, %i[x y]

    g = build_gate(%w[x OR 5])
    c = Circuit.new
    c << [:x, build_gate(['10'])]
    c.read(:x)
    assert g.signal(c), 15
  end

  def test_circuit
    c = Circuit.new
    c << [:z, build_gate(%w[x AND y])]
    c << [:x, build_gate(['123'])]
    c << [:w, build_gate(%w[NOT z])]
    c << [:y, build_gate(['456'])]

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

  class Gate
    attr_reader :inputs

    def initialize(op, *inputs)
      @op = op
      @inputs = inputs
    end

    def signal(circuit)
      args = inputs.map { |i| circuit.signal(i) }
      @op.call(*args) & 0xffff
    end
  end

  class Circuit
    def initialize
      @wires = {}
      @signals = {}
    end

    def <<(signal)
      @wires[signal[0]] = signal[1]
    end

    def signal(s)
      s.is_a?(Symbol) ? @signals[s] : s
    end

    def read(wire)
      queue = [wire]
      until queue.empty?
        w = queue[-1]
        unless @signals.key?(w)
          gate = @wires[w]
          missing = missing_signals(gate.inputs)
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

    def missing_signals(inputs)
      inputs.filter { |x| x.is_a?(Symbol) && !@signals.key?(x) }
    end

    def calculate_signal(wire, gate)
      @signals[wire] = gate.signal(self)
    end
  end

  DIGIT = /^[0-9]/.freeze

  OPERATIONS = {
    'AND' => :&,
    'OR' => :|,
    'LSHIFT' => :<<,
    'RSHIFT' => :>>
  }.freeze

  def val(v)
    DIGIT.match?(v) ? v.to_i : v.to_sym
  end

  def components(line)
    gate, wire = line.split(' -> ')
    [wire, gate.split]
  end

  def build_gate(parts)
    case parts.length
    when 1
      Gate.new(->(x) { x }, val(parts[0]))
    when 2
      Gate.new(->(x) { ~x }, val(parts[1]))
    when 3
      op = OPERATIONS[parts[1]]
      Gate.new(->(l, r) { l.send(op, r) }, val(parts[0]), val(parts[2]))
    end
  end

  def parse_line(line)
    wire, parts = components(line)
    [wire.to_sym, build_gate(parts)]
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
