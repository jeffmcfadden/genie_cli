module TDD
  class ReadFile < RubyLLM::Tool
    description "Reads the contents of a file and returns its content"
    param :filepath, desc: "The path to the file to read (e.g., '/home/user/documents/file.txt')"

    def execute(filepath:)
      TDD.output "Reading file: #{filepath}", color: :blue

      {
        contents: File.read(filepath),
      }
    rescue => e
      { error: e.message }
    end
  end
end