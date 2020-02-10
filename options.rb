require 'optparse'

class Options
  YEARS = %w[2015].freeze
  QUESTIONS = ('1'..'25').to_a.freeze
  QUESTION_MESSAGE = 'The problem-set question (1..25)'.freeze

  attr_reader :year, :question, :tests, :part_a, :part_b

  def initialize
    @tests = @part_a = @part_b = false

    @parser = OptionParser.new do |opt|
      required_flags(opt)
      choice_flags(opt)
      common_flags(opt)
    end
  end

  def required_flags(opt)
    opt.separator "\nRequired flags:"

    year_msg = "The problem-set year (#{YEARS.join ', '})"
    opt.on('-y', '--year YEAR', YEARS, year_msg) { |y| @year = y }

    opt.on('-q', '--question QUESTION', QUESTIONS, QUESTION_MESSAGE) do |q|
      @question = q
    end
  end

  def choice_flags(opt)
    opt.separator "\nRun Choice flags:"
    opt.on('-t', '--tests', 'Run test inputs') { @tests = true }
    opt.on('-a', '--partA', 'Run question part A') { @part_a = true }
    opt.on('-b', '--partB', 'Run question part B') { @part_b = true }
  end

  def common_flags(opt)
    opt.separator "\nCommon flags:"
    opt.on_tail('-h', '--help', 'Display this help message') do
      puts @parser
      exit
    end
  end

  def parse(args)
    parse_or_fail(args)
    validate_mandatory_flags
    validate_run_flags
    self
  end

  private

  def parse_or_fail(args)
    @parser.parse!(args)
  rescue OptionParser::MissingArgument, OptionParser::InvalidArgument => e
    puts e
    puts "\n", @parser
    exit 1
  end

  def validate_mandatory_flags
    return unless @year.nil? || @question.nil?

    puts "Both the --year and --question flags must be specified\n\n"
    puts @parser
    exit 2
  end

  def validate_run_flags
    active = [@tests, @part_a, @part_b].map { |b| b ? 1 : 0 }.sum
    return unless active != 1

    puts "Exactly one of --tests, --part_a, or --part_b must be specified\n\n"
    puts @parser
    exit 3
  end
end
