require "fileutils"

module Genie
  class InsertIntoFile < RubyLLM::Tool
    description "Insert a string into an existing file at a specified line number."
    param :filepath, desc: "The path to the file to insert into (e.g., '/home/user/documents/file.txt'). File must already exist."
    param :content, desc: "The content to insert into the file"
    param :line_number, desc: "The 1-based line number at which to insert the content"

    def initialize(base_path:)
      @base_path = base_path
      @base_path.freeze
    end

    def execute(filepath:, content:, line_number:)
      line_number = line_number.to_i

      # Expand the filepath to an absolute path
      filepath = File.expand_path(filepath)

      Genie.output "Inserting into file: #{filepath}", color: :blue

      # Ensure the file is within the allowed base path
      unless filepath.start_with?(@base_path)
        raise ArgumentError, "File not allowed: #{filepath}. Must be within base path: #{@base_path}"
      end

      # Check file exists
      unless File.exist?(filepath)
        raise "File not found. Cannot insert into a non-existent file."
      end

      # Read existing lines
      lines = File.readlines(filepath)

      # Validate line_number
      total_lines = lines.size
      if !line_number.is_a?(Integer) || line_number < 1 || line_number > total_lines + 1
        raise ArgumentError, "Invalid line number: #{line_number}. Must be between 1 and #{total_lines + 1}."
      end

      # Prepare content lines
      content_lines = content.each_line.to_a

      # Show the content to be inserted
      indented = content.each_line.map { |line| "  #{line}" }.join
      Genie.output indented, color: :green

      # Perform insertion
      index = line_number - 1
      new_lines = lines[0...index] + content_lines + lines[index..-1]

      # Write back
      File.open(filepath, "w") do |file|
        file.write(new_lines.join)
      end

      { success: true }
    rescue => e
      Genie.output "Error: #{e.message}", color: :red
      { error: e.message }
    end
  end
end
