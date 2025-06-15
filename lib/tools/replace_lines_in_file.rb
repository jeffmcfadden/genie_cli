require "ruby_llm"

module TDD
  class ReplaceLinesInFile < RubyLLM::Tool
    description "Replace lines in a file between start and end indices (inclusive) with new content."
    param :filepath, desc: "The path to the file to modify (must exist within base path)."
    param :start_line, desc: "Zero-based starting line index to replace."
    param :end_line, desc: "Zero-based ending line index to replace."
    param :content, desc: "The new content to insert in place of the removed lines."

    def initialize(base_path:)
      @base_path = base_path
      @base_path.freeze
    end

    def execute(filepath:, start_line:, end_line:, content:)
      # Expand to absolute path
      filepath = File.expand_path(filepath)
      TDD.output "Replacing lines in file: #{filepath}", color: :blue

      # Ensure within base path
      unless filepath.start_with?(@base_path)
        raise ArgumentError, "File not allowed: #{filepath}. Must be within base path: #{@base_path}"
      end

      # Check file exists
      unless File.exist?(filepath)
        raise "File not found. Cannot replace lines in a non-existent file."
      end

      # Read lines
      lines = File.readlines(filepath)
      total = lines.size

      # Validate indices
      if !start_line.is_a?(Integer) || !end_line.is_a?(Integer) || start_line < 0 || end_line < start_line || end_line >= total
        raise "Invalid line numbers: start=#{start_line}, end=#{end_line}, file has #{total} lines."
      end

      # Split head and tail
      head = lines[0...start_line]
      tail = lines[(end_line + 1)..-1] || []

      # Prepare new content lines
      new_lines = content.to_s.each_line.to_a

      # Combine
      updated = head + new_lines + tail

      # Write back
      File.open(filepath, "w") do |f|
        f.write(updated.join)
      end

      { success: true }
    rescue => e
      TDD.output "Error: #{e.message}", color: :red
      { error: e.message }
    end
  end
end
