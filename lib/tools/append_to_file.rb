require "fileutils"

module Genie
  class AppendToFile < RubyLLM::Tool
    description "Append a string to an existing file."
    param :filepath, desc: "The path to the file to append to (e.g., '/home/user/documents/file.txt'). File must already exist."
    param :content, desc: "The content to append to the file"

    def initialize(base_path:)
      @base_path = base_path
      @base_path.freeze
    end

    def execute(filepath:, content:)
      filepath = File.expand_path(filepath)

      Genie.output "Appending to file: #{filepath}", color: :blue

      unless filepath.start_with?(@base_path)
        raise ArgumentError, "File not allowed: #{filepath}. Must be within base path: #{@base_path}"
      end

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
