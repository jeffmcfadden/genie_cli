module Genie
  class TakeANote < RubyLLM::Tool
    description "Take a note. The user will see this note. It can be useful to remember something, or explain to the user what you're thinking."
    param :note, desc: "The text of the note you want stored."

    def execute(note:)
      Genie.output "Note: #{note}", color: :green

      {
        note: note,
      }
    end
  end
end