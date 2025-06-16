require_relative "test_helper"
require 'tmpdir'

class SessionConfigTest < TLDR
  def test_basic_session_config
    config = Genie::SessionConfig.new(
      base_path: "/my/cool/path",
      run_tests_cmd: "bundle exec testit",
      model: "gpt-4",
      first_question: "What is the meaning of life?",
      instructions: "Default instructions"
    )

    assert_equal "/my/cool/path", config.base_path
    assert_equal "bundle exec testit", config.run_tests_cmd
    assert_equal "gpt-4", config.model
    assert_equal "What is the meaning of life?", config.first_question
    assert config.instructions.include?("Default instructions")
  end

  def test_session_from_argv
    argv = ["-c", "asdf.yml", "--base-path", "/tmp", "--run-tests", "rake test", "--model", "gpt-4o", "--instructions", "Command line instructions", "What is the meaning of life?"]
    config = Genie::SessionConfig.from_argv(argv)

    assert_equal "/tmp", config.base_path
    assert_equal "rake test", config.run_tests_cmd
    assert_equal "gpt-4o", config.model
    assert_equal "What is the meaning of life?", config.first_question
    assert config.instructions.include?("Command line instructions")
  end

  def test_session_from_config_file
    argv = ["-c", "./test/data/sample_config.yml"]
    config = Genie::SessionConfig.from_argv(argv)
    expected_base_path = "/tmp/myapp/from_config"

    assert_equal File.realpath(expected_base_path), File.realpath(config.base_path)
    assert_equal "bundle exec tests_from_config_ex", config.run_tests_cmd
    assert_equal "test_model_from_config", config.model
    assert_equal nil, config.first_question
    assert config.instructions.include?("Instructions from config file")
  end

  def test_default_instructions
    config = Genie::SessionConfig.default
    default_instructions = config.instructions
    assert_includes default_instructions, "Genie coding assistant"
    assert_includes default_instructions, "Test Driven Development"
    assert_includes default_instructions, "tools available"
    assert_includes default_instructions, "write tests first"
    assert_includes default_instructions, "do not have access to any files outside"
    assert_includes default_instructions, "do not have access to the internet"
  end

end
