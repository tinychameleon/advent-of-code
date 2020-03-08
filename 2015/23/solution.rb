require './utils'

class Register < Numeric
  def initialize(val = 0)
    @val = val
  end

  def <=>(other)
    @val <=> other
  end

  def inc
    @val += 1
  end

  def hlf
    @val /= 2
  end

  def tpl
    @val *= 3
  end

  def even?
    @val.even?
  end

  def one?
    @val == 1
  end

  def to_i
    @val
  end
end

class Program
  attr_reader :instruction_counter

  def initialize(register_names, statements)
    @instruction_counter = 0
    @registers = register_names.each_with_object({}) do |name, rs|
      rs[name] = Register.new
    end
    @statements = statements
    @counter_range = 0...statements.size
  end

  def run!
    until (statement = @statements[@instruction_counter]).nil?
      op, *args = statement
      execute(op, args)
    end
  end

  def register(name)
    @registers[name].to_i
  end

  private

  def execute(op, args)
    case op
    when :inc, :tpl, :hlf
      @registers[args[0]].send(op)
      jump(1)
    when :jmp
      jump(args[0])
    when :jie, :jio
      reg, offset = args
      pred = op == :jie ? :even? : :one?
      jump(@registers[reg].send(pred) ? offset : 1)
    end
  end

  def jump(offset)
    @instruction_counter += offset
  end
end

class Solution
  TEST_INPUT = <<~DATA.freeze
    inc a
    jie a, +2
    tpl a
    inc b
  DATA

  TEST_PROGRAM = [
    [:inc, :a],
    [:jie, :a, 2],
    [:tpl, :a],
    [:inc, :b]
  ].freeze

  def tests
    r = Register.new(2)
    assert r, 2
    assert r.inc, 3
    assert r.tpl, 9
    assert r.hlf, 4

    assert read_program(TEST_INPUT), [[:a, :b], TEST_PROGRAM]

    program = Program.new([:a, :b], TEST_PROGRAM)
    assert program.instruction_counter, 0
    assert program.register(:b), 0
    program.run!
    assert program.register(:a), 3
    assert program.register(:b), 1
    :ok
  end

  def part_a
    solve_a(File.read('input'))
  end

  def part_b
    raise NotImplementedError
  end

  private

  def parse_statement(opstr, arg1, arg2 = nil)
    case opstr
    when 'inc', 'hlf', 'tpl'
      r = arg1.to_sym
      [r, [opstr.to_sym, r]]
    when 'jmp'
      [nil, [opstr.to_sym, arg1.to_i]]
    when 'jio', 'jie'
      r = arg1.to_sym
      [r, [opstr.to_sym, r, arg2.to_i]]
    end
  end

  def read_program(input)
    register_names = []
    statements = []
    input.lines.map { |l| l.chomp.split(/[, ]+/) }.each do |parts|
      register, statement = parse_statement(*parts)
      register_names << register unless register.nil?
      statements << statement
    end
    [register_names.sort.uniq, statements]
  end

  def solve_a(input)
    program = Program.new(*read_program(input))
    program.run!
    program.register(:b)
  end

  def solve_b(_input)
    raise NotImplementedError
  end
end
