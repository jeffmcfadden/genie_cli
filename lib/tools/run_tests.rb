module Genie
  class RunTests < RubyLLM::Tool
    description "Runs the test suite and returns the results"

    def initialize(base_path:, cmd:)
      @base_path = base_path
      @base_path.freeze

      @cmd = cmd || "rake test"
      @cmd.freeze
    end

    # Stubbed execute method; to be implemented in a future iteration
    def execute
      Genie.output "Running tests...", color: :blue

      # Run CMD within the base path
      Dir.chdir(@base_path) do
        begin
          output = `#{@cmd}`

          if $?.success?
            Genie.output "Tests passed successfully!", color: :green
            { result: "Tests passed", output: output }
          else
            Genie.output "Tests failed!", color: :red
            { result: "Tests failed", output: output }
          end
        rescue => e
          Genie.output "Error running tests: #{e.message}", color: :red
          { error: e.message }
        end
      end

    end
  end
end