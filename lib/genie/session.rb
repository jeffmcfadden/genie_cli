module Genie
  class Session
    extend Forwardable

    attr_reader :config

    # Supported commands to exit the session
    QUIT_COMMANDS = ["q", "quit", "done", "exit", "bye"].freeze

    # Config holds these for us
    def_delegators :@config, :model, :base_path, :run_tests_cmd, :instructions

    # Initializes the session with a pre-loaded configuration
    # config: instance of Genie::SessionConfig
    def initialize(config:)
      @config = config

      Genie.output "Starting a new session with:\n base_path: \\#{base_path}\n", color: :green

      # Initialize the LLM chat with the specified model
      @chat = RubyLLM.chat(model: model)

      # Use Genie-specific instructions from config
      @chat.with_instructions instructions

      # Provide file tools for the assistant, scoped to base_path
      @chat.with_tools(
        Genie::AppendToFile.new(base_path: base_path),
        Genie::AskForHelp.new,
        # Genie::InsertIntoFile.new(base_path: base_path),
        Genie::ListFiles.new(base_path: base_path),
        Genie::ReadFile.new(base_path: base_path),
        Genie::RenameFile.new(base_path: base_path),
        # Genie::ReplaceLinesInFile.new(base_path: base_path),
        Genie::RunTests.new(base_path: base_path, cmd: run_tests_cmd),
        Genie::TakeANote.new,
        Genie::WriteFile.new(base_path: base_path),
      )
    end

    def begin(q)
      q = q.to_s

      loop do
        complete if QUIT_COMMANDS.include? q.downcase

        begin
          ask q unless q.strip == ""
        rescue RubyLLM::RateLimitError => e
          Genie.output "Rate limit exceeded: #{e.message}", color: :red
        end

        q = prompt
      end
    end

    # Send a question to the LLM and output both prompt and response
    def ask(question)
      Genie.output "\\#{question}\n", color: :white

      response = @chat.ask(question)

      Genie.output "\n\\#{response.content}", color: :white

      response
    end

    def prompt
      print "\n > "
      STDIN.gets.chomp
    end

    def complete
      Genie.output "\nExiting...", color: :white

      total_conversation_tokens = @chat.messages.sum { |msg| (msg.input_tokens || 0) + (msg.output_tokens || 0) }
      Genie.output "Total Conversation Tokens: \\#{total_conversation_tokens}", color: :white

      exit
    end

  end
end
