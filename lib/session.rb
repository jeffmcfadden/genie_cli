module TDD
  class Session
    # Read-only base path for all file operations
    attr_reader :base_path

    def initialize(base_path:, model: "o4-mini")
      # Ensure base_path is provided
      # Ruby will raise ArgumentError for missing keyword argument if base_path is not given
      @base_path = base_path

      # Initialize the LLM chat with the specified model
      @chat = RubyLLM.chat(model: model)

      # Preload TDD-specific instructions
      @chat.with_instructions <<~INSTRUCTIONS
        # Context
        We are working in a codebase located at '#{base_path}'. 

        # TDD Instructions
        You are a TDD coding assistant. You help me write code using Test Driven Development
        (TDD) principles. You have some tools available to you, such as listing files,
        and you can write code in Ruby. You will always write tests first, and then implement
        the code to pass those tests. You will not write any code that does not have a test.
      
        # Rules
        1. We do not have access to any files outside of the base_path.
        2. We do not have access to the internet.
        3. You will always write tests first, and then implement the code to pass those tests.
      
      INSTRUCTIONS

      # Provide file tools for the assistant, scoped to base_path
      @chat.with_tools(
        TDD::ListFiles.new(base_path: base_path),
        TDD::ReadFile.new(base_path: base_path),
        TDD::WriteFile.new(base_path: base_path)
      )
    end

    # Send a question to the LLM and output both prompt and response
    def ask(question)
      TDD.output "#{question}\n", color: :white
      response = @chat.ask(question)
      TDD.output "\n#{response.content}", color: :blue

      response
    end
  end
end