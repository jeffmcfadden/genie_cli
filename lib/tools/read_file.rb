module TDD
  class ReadFile < RubyLLM::Tool
    description "Reads the contents of a file and returns its content"
    param :filepath, desc: "The path to the file to read (e.g., '/home/user/documents/file.txt')"

    def initialize(base_path:)
      @base_path = base_path
      @base_path.freeze
    end

    def execute(filepath:)
      filepath = File.expand_path(filepath)

      TDD.output "Reading file: #{filepath}", color: :blue

      raise ArgumentError, "File not allowed: #{filepath}. Must be within base path: #{@base_path}" unless filepath.start_with?(@base_path)

      {
        contents: File.read(filepath),
      }
    rescue => e
      TDD.output "Error: #{e.message}", color: :red

      { error: e.message }
    end
  end
end