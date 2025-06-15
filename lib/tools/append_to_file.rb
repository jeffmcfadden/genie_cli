require "fileutils"

module TDD
  class AppendToFile < RubyLLM::Tool
    description "Append a string to an existing file."
    param :filepath, desc: "The path to the file to append to (e.g., '/home/user/documents/file.txt'). File must already exist."
    param :content, desc: "The content to append to the file"

    def initialize(base_path:)
      @base_path = base_path
      @base_path.freeze
    end

    def execute(filepath:, content:)
      # Expand the filepath to an absolute path
      filepath = File.expand_path(filepath)

      TDD.output "Appending to file: #{filepath}", color: :blue

      # Ensure the file is within the allowed base path
      unless filepath.start_with?(@base_path)
        raise ArgumentError, "File not allowed: #{filepath}. Must be within base path: #{@base_path}"
      end

      # Print the content to be appended
      indented = content.each_line.map { |line| "  #{line}" }.join
      TDD.output indented, color: :green

      raise "File not found. Cannot append to a non-existent file." unless File.exist?(filepath)

      # Append the content
      File.open(filepath, "a") do |file|
        file.write(content)
      end

      { success: true }
    rescue => e
      TDD.output "Error: #{e.message}", color: :red
      { error: e.message }
    end
  end
end