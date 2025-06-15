require 'optparse'

module Genie

  class Cli
    # CLI class handles command-line invocation and session lifecycle
    attr_reader :options, :args

    def initialize(argv)
      @options = {}
      @args = Array(argv)

      OptionParser.new do |parser|
        parser.banner = "Usage: genie [options] [question]"
        parser.on("--version")
        parser.on("-h", "--help")
      end.parse!(@args, into: @options)
    end

    def run
      config_file = File.join(Dir.pwd, 'genie.yml')
      if File.exist?(config_file)
        config = SessionConfig.from_file(config_file, base_path: Dir.pwd)
        Genie.output "Using config from \\#{config_file}", color: :blue
      else
        config = SessionConfig.default(base_path: Dir.pwd)
        Genie.output "Using default config", color: :blue
      end

      session = Session.new(config: config)

      # Trap CTRL+C to exit gracefully
      Signal.trap("INT") { session.complete }

      # Begin the session with the first CLI argument (or nil)
      session.begin(@argv[0])
    end
  end
end
