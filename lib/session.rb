module TDD
  class Session
    def initialize(model: "o4-mini")
      @chat = RubyLLM.chat(model: model)

      @instructions = instructions

      @chat.with_instructions <<~INSTRUCTIONS
  You are a TDD coding assistant. You help me write code using Test Driven Development 
  (TDD) principles. You have some tools available to you, such as listing files,
  and you can write code in Ruby. You will always write tests first, and then implement
  the code to pass those tests. You will not write any code that does not have a test.

      INSTRUCTIONS

      @chat.with_tools(TDD::ListFiles.new, TDD::ReadFile.new, TDD::WriteFile.new)
    end

    def ask(question)
      TDD.output "#{question}", color: :white
      response = @chat.ask(question)
      TDD.output "#{response}", color: blue

      response
    end




  end
end