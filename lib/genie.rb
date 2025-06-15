require "ruby_llm"
require "dotenv/load"

$LOAD_PATH.unshift (File.expand_path('../lib', __dir__))

require "session_config"
require "session"
require "tools/append_to_file"
require "tools/list_files"
require "tools/read_file"
require "tools/write_file"
require "tools/replace_lines_in_file"
require "tools/rename_file"
require "tools/run_tests"
require "tools/take_a_note"
require "tools/insert_into_file"
require "tools/ask_for_help"

RubyLLM.configure do |config|
  # Set keys for the providers you need. Using environment variables is best practice.
  config.openai_api_key = ENV.fetch('OPENAI_API_KEY', nil)
  # Add other keys like config.anthropic_api_key if needed

  config.log_file = 'ruby_llm.log'  # Log file path
  config.log_level = :debug  # Log level (:debug, :info, :warn)
end

module Genie
  def self.output(s, color: :white)
    return if quiet?

    # This method is used to output messages in a consistent format.
    # You can customize the color or format as needed.
    puts "\e[32m#{s}\e[0m" if color == :green
    puts "\e[31m#{s}\e[0m" if color == :red
    puts "\e[33m#{s}\e[0m" if color == :yellow
    puts "\e[34m#{s}\e[0m" if color == :blue
    puts "\e[35m#{s}\e[0m" if color == :magenta
    puts "\e[36m#{s}\e[0m" if color == :cyan

    puts "\e[37m#{s}\e[0m" if color == :white
  end

  def self.quiet=(value)
    # This method can be used to set a quiet mode for the output.
    # If true, it suppresses the output.
    @quiet = value
  end

  def self.quiet?
    @quiet || false
  end

  def self.reset_quiet!
    @quiet = false
  end

  def self.quiet!
    # This method can be used to enable quiet mode.
    @quiet = true
  end

end
