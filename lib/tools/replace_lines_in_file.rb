require "ruby_llm"

module Genie
  class ReplaceLinesInFile < RubyLLM::Tool
    include SandboxedFileTool

    description "Replace lines in a file between start and end indices (inclusive) with new content."
    param :filepath, desc: "The path to the file to modify (must exist within base path)."
    param :start_line, desc: "Zero-based starting line index to replace."
    param :end_line, desc: "Zero-based ending line index to replace."
    param :content, desc: "The new content to insert in place of the removed lines."

    def execute(filepath:, start_line:, end_line:, content:)
      start_line = start_line.to_i
      end_line = end_line.to_i

      # Expand to absolute path
      filepath = File.expand_path(filepath)
      Genie.output "Replacing lines in file: #{filepath}", color: :blue

      enforce_sandbox!(filepath)

      # Check file exists
      unless File.exist?(filepath)
        raise "File not found. Cannot replace lines in a non-existent file."
      end

      # Read lines
      lines = File.readlines(filepath)
      total = lines.size

      # Validate indices
      if !start_line.is_a?(Integer) || !end_line.is_a?(Integer) || start_line < 0 || end_line < start_line || end_line > total
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
      Genie.output "Error: #{e.message}", color: :red
      { error: e.message }
    end
  end
end
