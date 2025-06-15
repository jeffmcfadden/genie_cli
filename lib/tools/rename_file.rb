require "fileutils"
require "ruby_llm"

module Genie
  class RenameFile < RubyLLM::Tool
    include SandboxedFileTool

    description "Rename a file within the base path to a new location within the base path."
    param :filepath, desc: "The path to the source file to rename."
    param :new_path, desc: "The new path for the file."

    def execute(filepath:, new_path:)
      # Expand to absolute paths
      src = File.expand_path(filepath)
      dst = File.expand_path(new_path)

      Genie.output "Renaming file from: #{src} to #{dst}", color: :blue

      enforce_sandbox!(src)
      enforce_sandbox!(dst)

      # Check source exists
      unless File.exist?(src)
        raise "File not found. Cannot rename a non-existent file."
      end

      # Check destination does not exist
      if File.exist?(dst)
        raise "Destination already exists: #{dst}."
      end

      # Ensure destination directory exists
      dest_dir = File.dirname(dst)
      FileUtils.mkdir_p(dest_dir) unless Dir.exist?(dest_dir)

      # Perform rename
      FileUtils.mv(src, dst)

      { success: true }
    rescue => e
      Genie.output "Error: #{e.message}", color: :red
      { error: e.message }
    end
  end
end
