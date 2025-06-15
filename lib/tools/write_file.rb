require "fileutils"

module TDD
  class WriteFile < RubyLLM::Tool
    description "Write a string to a file"
    param :filepath, desc: "The path to the file to read (e.g., '/home/user/documents/file.txt')"
    param :content, desc: "The content to write to the file"

    def initialize(base_path:)
      @base_path = base_path
      @base_path.freeze
    end

    def execute(filepath:, content:)
      filepath = File.expand_path(filepath)

      TDD.output "Writing file: #{filepath}", color: :blue

      raise ArgumentError, "File not allowed: #{filepath}. Must be within base path: #{@base_path}" unless filepath.start_with?(@base_path)

      indented_content = content.each_line.map { |line| "  #{line}" }.join

      TDD.output "#{indented_content}", color: :green

      # Ensure the directory exists
      FileUtils.mkdir_p(File.dirname(filepath))

      File.open(filepath, "w") do |file|
        file.write(content)
      end

      {
        success: true,
      }
    rescue => e
      TDD.output "Error: #{e.message}", color: :red

      { error: e.message }
    end
  end
end