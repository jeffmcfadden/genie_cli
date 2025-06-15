module TDD
  class Session
    # Read-only base path for all file operations
    attr_reader :base_path

    QUIT_COMMANDS = ["q", "quit", "done", "exit"]

    def initialize(base_path:, model: "o4-mini", run_tests_cmd:)

      TDD.output "Starting a new session with:\n base_path: #{base_path}\n", color: :green

      # Ensure base_path is provided
      # Ruby will raise ArgumentError for missing keyword argument if base_path is not given
      @base_path = base_path

      @run_tests_cmd = run_tests_cmd

      # Initialize the LLM chat with the specified model
      @chat = RubyLLM.chat(model: model)

      # Preload TDD-specific instructions
      @chat.with_instructions <<~INSTRUCTIONS
        # Context
        Current Date and Time: #{Time.now.iso8601}
        We are working in a codebase located at '#{base_path}'.

        # TDD Instructions
        You are a TDD coding assistant. You help me write code using Test Driven Development
        (TDD) principles. You have some tools available to you, such as listing files, reading files, and writing files,
        and you can write code in Ruby. You will always write tests first, and then implement
        the code to pass those tests. You will not write any code that does not have a test.
      
        # Rules
        1. We do not have access to any files outside of the base_path.
        2. We do not have access to the internet.
        3. You will always write tests first, and then implement the code to pass those tests.
      
      INSTRUCTIONS

      # Provide file tools for the assistant, scoped to base_path
      @chat.with_tools(
        TDD::AppendToFile.new(base_path: base_path),
        TDD::AskForHelp.new,
        TDD::InsertIntoFile.new(base_path: base_path),
        TDD::ListFiles.new(base_path: base_path),
        TDD::ReadFile.new(base_path: base_path),
        TDD::RunTests.new(base_path: base_path, cmd: @run_tests_cmd),
        TDD::TakeANote.new,
        TDD::WriteFile.new(base_path: base_path),
      )
    end

    def begin(q)
      q = q.to_s

      loop do
        complete if QUIT_COMMANDS.include? q.downcase

        begin
          ask q unless q.strip == ""
        rescue RubyLLM::RateLimitError => e
          TDD.output "Rate limit exceeded: #{e.message}", color: :red
        end

        q = prompt
      end
    end

    # Send a question to the LLM and output both prompt and response
    def ask(question)
      TDD.output "#{question}\n", color: :white

      response = @chat.ask(question)

      TDD.output "\n#{response.content}", color: :white

      response
    end

    def prompt
      print "\n > "
      STDIN.gets.chomp
    end

    def complete
      TDD.output "\nExiting...", color: :white

      total_conversation_tokens = @chat.messages.sum { |msg| (msg.input_tokens || 0) + (msg.output_tokens || 0) }
      TDD.output "Total Conversation Tokens: #{total_conversation_tokens}", color: :white

      exit
    end

  end
end