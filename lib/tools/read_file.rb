module Genie
  class ReadFile < RubyLLM::Tool
    include SandboxedFileTool

    description "Reads the contents of a file and returns its content"
    param :filepath, desc: "The path to the file to read (e.g., '/home/user/documents/file.txt')"
    param :include_line_numbers, desc: "Whether to include line numbers (default: false)"

    def execute(filepath:, include_line_numbers: false)
      filepath = File.expand_path(filepath)

      Genie.output "Reading file: #{filepath}", color: :blue

      enforce_sandbox!(filepath)

      lines = File.readlines(filepath)
      contents = if include_line_numbers
        width = lines.size.to_s.length
        lines.each_with_index.map do |line, index|
          number = (index + 1).to_s.rjust(width)
          "#{number}: #{line}"
        end.join
      else
        lines.join
      end

      { contents: contents }
    rescue => e
      Genie.output "Error: #{e.message}", color: :red

      { error: e.message }
    end
  end
end
