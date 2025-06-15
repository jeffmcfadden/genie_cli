require "fileutils"

module TDD
  class WriteFile < RubyLLM::Tool
    description "Write a string to a file"
    param :filepath, desc: "The path to the file to read (e.g., '/home/user/documents/file.txt')"
    param :content, desc: "The content to write to the file"

    def execute(filepath:, content:)
      TDD.output "Writing file: #{filepath}", color: :blue

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
      { error: e.message }
    end
  end
end