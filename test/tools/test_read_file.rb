require "tools/read_file"
require 'tmpdir'

class TestReadFile < TLDR
  def setup
    @tmp_dir = Dir.mktmpdir
    @file_path = File.join(@tmp_dir, "read_file_test.txt")
    File.write(@file_path, "Line1\nLine2\nLine3\n")
  end

  def teardown
    FileUtils.remove_entry(@tmp_dir)
  end

  def test_read_file_without_line_numbers
    actual = Genie::ReadFile.new(base_path: @tmp_dir).execute(filepath: @file_path)
    expected_contents = "Line1\nLine2\nLine3\n"
    assert_equal({ contents: expected_contents }, actual)
  end

  def test_read_file_with_line_numbers
    actual = Genie::ReadFile.new(base_path: @tmp_dir).execute(filepath: @file_path, include_line_numbers: true)
    expected_contents = "1: Line1\n2: Line2\n3: Line3\n"
    assert_equal({ contents: expected_contents }, actual)
  end
end
