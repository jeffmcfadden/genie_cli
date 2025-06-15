require_relative "test_helper"
require 'yaml'

class CliTest < TLDR

  def test_runs_without_blowing_up
    Genie::Cli.new(['testing 123'])
  end
  
  def test_options_default_empty_and_args_equal_init_argv
    argv = ['foo', 'bar']
    cli = Genie::Cli.new(argv.dup)
    assert_equal({}, cli.options)
    assert_equal(argv, cli.args)
  end

  def test_parses_version_flag_and_args
    argv = ['--version', 'start']
    cli = Genie::Cli.new(argv.dup)
    assert_equal(true, cli.options[:version])
    assert_equal(['start'], cli.args)
  end
end
