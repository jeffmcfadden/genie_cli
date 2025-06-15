module TDD
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
      TDD.output "Running tests...", color: :blue

      # Run CMD within the base path
      Dir.chdir(@base_path) do
        begin
          output = `#{@cmd}`

          if $?.success?
            TDD.output "Tests passed successfully!", color: :green
            { result: "Tests passed", output: output }
          else
            TDD.output "Tests failed!", color: :red
            { result: "Tests failed", output: output }
          end
        rescue => e
          TDD.output "Error running tests: #{e.message}", color: :red
          { error: e.message }
        end
      end

    end
  end
end