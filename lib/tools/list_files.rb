module TDD

  class ListFiles < RubyLLM::Tool
    description "Lists the files in the given directory"
    param :directory, desc: "Directory path to list files from (e.g., '/home/user/documents')"
    param :recursive, desc: "Whether to list files recursively (default: false)"

    def initialize(base_path:)
      @base_path = base_path
      @base_path.freeze
    end

    def execute(directory:, recursive: false)
      directory = File.expand_path(directory, @base_path)

      TDD.output "Listing files in directory: #{directory} (recursive: #{recursive})", color: :blue

      raise ArgumentError, "Directory not allowed: #{directory}. Must be within base path: #{@base_path}" unless directory.start_with?(@base_path)

      listing = (recursive ? list_recursive(directory) : list_non_recursive(directory))

      TDD.output listing.join("\n") + "\n", color: :green

      listing
    rescue => e
      TDD.output "Error: #{e.message}", color: :red
      { error: e.message }
    end

    private

    def list_recursive(directory)
      Dir.glob(File.join(directory, '**', '*')).map do |file_path|
        # next if File.basename(file_path).start_with?('.') # Skip hidden files

        {
          name: file_path,
          type: File.file?(file_path) ? 'file' : 'directory',
        }
      end.compact
    end

    def list_non_recursive(directory)
      Dir.each_child(directory).map do |filename|
        next if filename.start_with?('.') # Skip hidden files

        file_path = File.join(directory, filename)

        {
          name: filename,
          type: File.file?(file_path) ? 'file' : 'directory',
        }
      end.compact # Remove any nil entries (e.g., hidden files or directories)
    end

  end

end