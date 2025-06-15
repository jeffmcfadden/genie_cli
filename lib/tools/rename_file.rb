require "fileutils"
require "ruby_llm"

module TDD
  class RenameFile < RubyLLM::Tool
    description "Rename a file within the base path to a new location within the base path."
    param :filepath, desc: "The path to the source file to rename."
    param :new_path, desc: "The new path for the file."

    def initialize(base_path:)
      @base_path = base_path
      @base_path.freeze
    end

    def execute(filepath:, new_path:)
      # Expand to absolute paths
      src = File.expand_path(filepath)
      dst = File.expand_path(new_path)

      TDD.output "Renaming file from: #{src} to #{dst}", color: :blue

      # Ensure both paths are within base path
      unless src.start_with?(@base_path)
        raise ArgumentError, "File not allowed: #{src}. Must be within base path: #{@base_path}"
      end
      unless dst.start_with?(@base_path)
        raise ArgumentError, "Destination not allowed: #{dst}. Must be within base path: #{@base_path}"
      end

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
      TDD.output "Error: #{e.message}", color: :red
      { error: e.message }
    end
  end
end
