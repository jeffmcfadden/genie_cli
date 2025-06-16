require_relative "test_helper"
require 'tmpdir'

class SessionTest < TLDR

  def test_session_does_not_blow_up
    config = Genie::SessionConfig.default
    session = Genie::Session.new(config: config)

    refute_equal nil, session
  end

end
