require_relative "test_helper"
require 'tmpdir'

class SessionConfigTest < TLDR
  def test_basic_session_config
    config = Genie::SessionConfig.new(
      base_path: "/my/cool/path",
      run_tests_cmd: "bundle exec testit",
      model: "gpt-4",
      first_question: "What is the meaning of life?"
    )

    assert_equal "/my/cool/path", config.base_path
    assert_equal "bundle exec testit", config.run_tests_cmd
    assert_equal "gpt-4", config.model
    assert_equal "What is the meaning of life?", config.first_question
  end

  def test_session_from_argv
    argv = ["-c", "asdf.yml", "--base-path", "/tmp", "--run-tests", "rake test", "--model", "gpt-4o", "What is the meaning of life?"]
    config = Genie::SessionConfig.from_argv(argv)

    assert_equal "/tmp", config.base_path
    assert_equal "rake test", config.run_tests_cmd
    assert_equal "gpt-4o", config.model
    assert_equal "What is the meaning of life?", config.first_question
  end

  def test_session_from_config_file
    argv = ["-c", "./test/data/sample_config.yml"]
    config = Genie::SessionConfig.from_argv(argv)

    assert_equal "/tmp/myapp/from_config", config.base_path
    assert_equal "bundle exec tests_from_config_ex", config.run_tests_cmd
    assert_equal "test_model_from_config", config.model
    assert_equal nil, config.first_question
  end


end
