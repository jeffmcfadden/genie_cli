require 'yaml'

module TDD
  # Handles loading of session configuration such as run_tests_cmd
  class SessionConfig
    # Read-only attributes
    attr_reader :base_path, :run_tests_cmd

    # Initializes configuration with explicit run_tests_cmd
    # Requires both base_path and run_tests_cmd
    def initialize(base_path:, run_tests_cmd:)
      @base_path = base_path
      @run_tests_cmd = run_tests_cmd
    end

    # Loads configuration from tddcli.yml in base_path
    # Raises ArgumentError if file missing or run_tests_cmd missing/empty
    def self.from_file(filepath)
      config_file = File.expand_path(filepath)
      unless File.exist?(config_file)
        raise ArgumentError, 'Configuration file #{config_file} not found'
      end

      config_hash = YAML.load_file(config_file)
      cmd = config_hash['run_tests_cmd']
      base_path = config_hash['base_path']
      if cmd.nil? || cmd.to_s.strip.empty?
        raise ArgumentError, 'run_tests_cmd not found in config file'
      end

      new(base_path: base_path, run_tests_cmd: cmd)
    end
  end
end
