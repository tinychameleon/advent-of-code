# Advent of Code

This repository contains solutions to [Advent of Code](https://adventofcode.com/)
puzzles.


## Running Solutions

The [main.rb](./main.rb) file is a small command-line program that can run
questions from selected years. Use `bin/run -h` to see its capabilities.

If you have [direnv](https://direnv.net/), you can issue commands in a shorter
form: `run -h`.


## Creating Solutions

The [template file](./solution.rb.template) can be copied into the correct
location to begin work on a new question. For example:

```
$ cp solution.rb.template 2015/5/solution.rb
```

Code quality checks can be done by running `bundle exec rubocop`.
