module TDD
  class AskForHelp < RubyLLM::Tool
    description "Ask for help. If you can't seem to get something to work, or you get repeated errors, use this tool to ask the user to intervene. Use only when absolutely necessary."
    param :message, desc: "The message you want the user to see. Include any helpful details!"

    def execute(message:)
      TDD.output "Help! \n#{message}\n", color: :red

      {
        status: "User has been asked for help. We should wait until we get input from them.",
      }
    end
  end
end