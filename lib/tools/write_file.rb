require "fileutils"

module Genie
  class WriteFile < RubyLLM::Tool
    include SandboxedFileTool

    description "Write a string to a file"
    param :filepath, desc: "The path to the file to read (e.g., '/home/user/documents/file.txt')"
    param :content, desc: "The content to write to the file"

    def execute(filepath:, content:)
      filepath = File.expand_path(filepath)

      Genie.output "Writing file: #{filepath}", color: :blue

      enforce_sandbox!(filepath)

      indented_content = content.each_line.map { |line| "  #{line}" }.join

      Genie.output "#{indented_content}", color: :green

      # Ensure the directory exists
      FileUtils.mkdir_p(File.dirname(filepath))

      File.open(filepath, "w") do |file|
        file.write(content)
      end

      {
        success: true,
      }
    rescue => e
      Genie.output "Error: #{e.message}", color: :red

      { error: e.message }
    end
  end
end