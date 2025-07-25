require "fileutils"

module Genie
  class AppendToFile < RubyLLM::Tool
    include SandboxedFileTool

    description "Append a string to an existing file."
    param :filepath, desc: "The path to the file to append to (e.g., '/home/user/documents/file.txt'). File must already exist."
    param :content, desc: "The content to append to the file"

    def execute(filepath:, content:)
      filepath = File.expand_path(filepath)

      Genie.output "Appending to file: #{filepath}", color: :blue

      enforce_sandbox!(filepath)

      indented = content.each_line.map { |line| "  #{line}" }.join
      Genie.output indented, color: :green

      raise "File not found. Cannot append to a non-existent file." unless File.exist?(filepath)

      File.open(filepath, "a") do |file|
        file.write(content)
      end

      { success: true }
    rescue => e
      Genie.output "Error: #{e.message}", color: :red
      { error: e.message }
    end
  end
end
