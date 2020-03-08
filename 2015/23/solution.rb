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

class Compiler
  attr_reader :registers, :statements

  def initialize(input)
    @registers = []
    @statements = []

    input.lines.map { |l| l.chomp.split(/[, ]+/) }.each do |parts|
      r, s = parse_statement(*parts)
      @registers << r unless r.nil?
      @statements << s
    end

    @registers.sort!.uniq!
  end

  def program(**initial_registers)
    rs = registers.each_with_object({}) do |name, regs|
      regs[name] = initial_registers.fetch(name, 0)
    end
    Program.new(rs, statements)
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
end

class Program
  attr_reader :instruction_counter

  def initialize(registers, statements)
    @instruction_counter = 0
    @registers = registers.transform_values { |v| Register.new(v) }
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

    c = Compiler.new(TEST_INPUT)
    assert c.registers, [:a, :b]
    assert c.statements, TEST_PROGRAM

    prog = c.program
    assert prog.instruction_counter, 0
    assert prog.register(:b), 0
    prog.run!
    assert prog.register(:a), 3
    assert prog.register(:b), 1

    prog2 = c.program(b: 99)
    assert prog2.register(:b), 99
    :ok
  end

  def part_a
    solve_a(File.read('input'))
  end

  def part_b
    solve_b(File.read('input'))
  end

  private

  def solve_a(input)
    program = Compiler.new(input).program
    program.run!
    program.register(:b)
  end

  def solve_b(input)
    program = Compiler.new(input).program(a: 1)
    program.run!
    program.register(:b)
  end
end
