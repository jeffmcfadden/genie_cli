require_relative "test_helper"
require 'tmpdir'

class SessionConfigTest < TLDR
  def test_initialize_sets_base_path_and_run_tests_cmd_when_provided
    base = "/path/to/project"
    config = TDD::SessionConfig.new(base_path: base, run_tests_cmd: "ls")
    assert_equal base, config.base_path
    assert_equal "ls", config.run_tests_cmd
  end

  def test_base_path_and_run_tests_cmd_are_read_only
    config = TDD::SessionConfig.new(base_path: "/foo", run_tests_cmd: "ls")
    assert_raises(NoMethodError) { config.base_path = "/bar" }
    assert_raises(NoMethodError) { config.run_tests_cmd = "pwd" }
  end

  def test_from_file_loads_run_tests_cmd
    Dir.mktmpdir do |dir|
      config_hash = {'run_tests_cmd' => 'foobar', 'base_path' => '/example' }
      tmp_config_filepath = File.join(dir, 'tddcli.yml')

      File.write(tmp_config_filepath, config_hash.to_yaml)

      config = TDD::SessionConfig.from_file(tmp_config_filepath)
      assert_equal '/example', config.base_path
      assert_equal 'foobar', config.run_tests_cmd
    end
  end

  def test_from_file_missing_file_raises
    Dir.mktmpdir do |dir|
      assert_raises(ArgumentError) { TDD::SessionConfig.from_file("/does/not/exist.yml") }
    end
  end

  def test_from_file_empty_run_tests_cmd_raises
    Dir.mktmpdir do |dir|
      config_hash = {'run_tests_cmd' => '   '}

      tmp_config_filepath = File.join(dir, 'tddcli.yml')

      File.write(tmp_config_filepath, config_hash.to_yaml)
      assert_raises(ArgumentError) { TDD::SessionConfig.from_file(tmp_config_filepath) }
    end
  end

  def test_missing_run_tests_cmd_raises
    Dir.mktmpdir do |dir|
      assert_raises(ArgumentError) { TDD::SessionConfig.new(base_path: dir) }
    end
  end

  def test_default_returns_config_with_defaults
    expected_base = Dir.pwd
    expected_run_tests_cmd = "rake test"
    config = TDD::SessionConfig.default
    assert_equal expected_base, config.base_path
    assert_equal expected_run_tests_cmd, config.run_tests_cmd
  end
end
