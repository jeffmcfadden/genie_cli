require 'optparse'

module Genie

  class Cli
    def initialize(config:)
      @config = config
    end

    def run
      session = Session.new(config: @config)

      # Trap CTRL+C to exit gracefully
      Signal.trap("INT") { session.complete }

      # Begin the session with the first CLI argument (or nil)
      session.begin(@args&.last)
    end
  end
end
