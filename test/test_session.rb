require_relative "test_helper"
require 'tmpdir'

class SessionTest < TLDR
  def test_initialize_sets_base_path_and_run_tests_cmd
    base = "/path/to/project"
    config = TDD::SessionConfig.new(base_path: base, run_tests_cmd: "ls")
    session = TDD::Session.new(config: config)

    assert_equal base, session.base_path
    assert_equal "ls", session.run_tests_cmd
  end

  def test_base_path_is_read_only
    config = TDD::SessionConfig.new(base_path: "/foo", run_tests_cmd: "ls")
    session = TDD::Session.new(config: config)
    assert_raises(NoMethodError) do
      session.base_path = "/bar"
    end
  end

  def test_missing_config_raises
    assert_raises(ArgumentError) do
      TDD::Session.new
    end
  end

  def test_run_tests_cmd_from_config
    Dir.mktmpdir do |dir|
      config_hash = {'run_tests_cmd' => 'foobar'}

      tmp_config_file_path = File.join(dir, 'tddcli.yml')

      File.write(tmp_config_file_path, config_hash.to_yaml)
      config = TDD::SessionConfig.from_file(tmp_config_file_path)
      session = TDD::Session.new(config: config)
      assert_equal 'foobar', session.run_tests_cmd
    end
  end
end
