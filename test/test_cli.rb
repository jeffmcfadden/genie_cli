require_relative "test_helper"
require 'yaml'

class CliTest < TLDR

  def test_runs_without_blowing_up
    Genie::Cli.new(['testing 123'])
  end

end
