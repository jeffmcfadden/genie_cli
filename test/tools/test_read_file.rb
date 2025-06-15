require "tools/read_file"
require 'debug'

class TestReadFile < TLDR
  def setup
    @base_path = File.expand_path("../../", __dir__)
    @file_path = File.expand_path "./test/data/sample_files/read_file_test.txt"
  end

  def test_read_file_without_line_numbers
    actual = Genie::ReadFile.new(base_path: @base_path).execute(filepath: @file_path)
    expected_contents = "Line1\nLine2\nLine3\n"
    assert_equal({ contents: expected_contents }, actual)
  end

  def test_read_file_with_line_numbers
    actual = Genie::ReadFile.new(base_path: @base_path).execute(filepath: @file_path, include_line_numbers: true)
    expected_contents = "1: Line1\n2: Line2\n3: Line3\n"
    assert_equal({ contents: expected_contents }, actual)
  end
end
