require './options'

class Driver
  def self.launch(args)
    options = Options.new.parse(args)
    workdir = "./#{options.year}/#{options.question}"
    require "#{workdir}/solution"
    run_solution(workdir, options)
  end

  def self.run_solution(pwd, options)
    Dir.chdir(pwd)
    if options.tests
      Solution.new.tests
    elsif options.part_a
      Solution.new.part_a
    else
      Solution.new.part_b
    end
  end
end

puts Driver.launch ARGV
