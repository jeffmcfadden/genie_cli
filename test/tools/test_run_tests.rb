require "tools/run_tests"

class TestRunTests < TLDR
  def test_execute_not_implemented
    run_tests_tool = TDD::RunTests.new(base_path: "/tmp", cmd: "ls")

    run_tests_tool.execute
  end
end
