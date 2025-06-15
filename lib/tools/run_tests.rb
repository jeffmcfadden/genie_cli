module TDD
  class RunTests < RubyLLM::Tool
    description "Runs the test suite and returns the results"

    # Stubbed execute method; to be implemented in a future iteration
    def execute
      TDD.output "Running tests...", color: :blue

      raise NotImplementedError, "RunTests tool is not implemented yet"
    end
  end
end