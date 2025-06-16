require_relative "test_helper"
require 'yaml'

class CliTest < TLDR

  def test_runs_without_blowing_up
    config = Genie::SessionConfig.default
    Genie::Cli.new(config: config)
  end

end
