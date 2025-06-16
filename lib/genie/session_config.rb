require 'yaml'

module Genie
  # Handles loading of session configuration such as run_tests_cmd
  class SessionConfig
    # Read-only attributes
    attr_reader :base_path, :run_tests_cmd, :model, :first_question

    DEFAULTS = {
      base_path: ".",
      run_tests_cmd: 'rake test',
      model: 'gpt-4o',
      first_question: nil
    }

    def self.from_argv(argv)
      cli_options = {}
      config_file = File.expand_path "./genie.yml"

      OptionParser.new do |opts|
        opts.banner = "Usage: genie [options]"

        opts.on("-c", "--config FILE", "Path to config file") do |file|
          config_file = File.expand_path(file)
        end

        opts.on("-b", "--base-path PATH", "Base path for the session") do |path|
          cli_options[:base_path] = path
        end

        opts.on("-r", "--run-tests CMD", "Command to run tests") do |cmd|
          cli_options[:run_tests_cmd] = cmd
        end

        opts.on("-m", "--model NAME", "Name of model to use") do |name|
          cli_options[:model] = name
        end

        opts.on("-v", "--[no-]verbose", "Enable verbose mode") do |v|
          cli_options['verbose'] = v
        end
      end.parse!(argv)

      # Last remaining argument is the first question
      cli_options[:first_question] = argv.last if argv.any?

      file_config = {}
      if config_file && File.exist?(config_file)
        file_config = YAML.load_file(config_file, symbolize_names: true)
      end

      # 3️⃣ Merge: DEFAULT < FILE < CLI
      final_config = DEFAULTS.merge(file_config).merge(cli_options)

      new(
        base_path: final_config[:base_path],
        run_tests_cmd: final_config[:run_tests_cmd],
        model: final_config[:model],
        first_question: final_config[:first_question]
      )
    end

    def self.default
      new(
        base_path: DEFAULTS[:base_path],
        run_tests_cmd: DEFAULTS[:run_tests_cmd],
        model: DEFAULTS[:model],
        first_question: DEFAULTS[:first_question]
      )
    end

    def initialize(base_path:, run_tests_cmd:, model:, first_question:)    # Requires both base_path and run_tests_cmd
      @base_path = File.expand_path(base_path)
      @run_tests_cmd = run_tests_cmd
      @model = model
      @first_question = first_question
    end

  end
end
