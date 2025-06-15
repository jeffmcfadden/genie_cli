module Genie
  module SandboxedFileTool


    def initialize(base_path:)
      @base_path = base_path
      @base_path.freeze
    end

    def within_sandbox?(filepath)
      filepath = File.expand_path(filepath)
      filepath.start_with?(@base_path)
    end

    def enforce_sandbox!(filepath)
      unless within_sandbox?(filepath)
        raise ArgumentError, "File not allowed: #{filepath}. Must be within base path: #{@base_path}"
      end
    end

  end
end