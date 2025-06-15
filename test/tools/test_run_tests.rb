require "tools/run_tests"

class TestRunTests < TLDR
  def test_execute_not_implemented
    run_tests_tool = TDD::RunTests.new
    assert_raises(NotImplementedError) do
      run_tests_tool.execute
    end
  end
end
