require "tmpdir"

class TestReplaceLinesInFile < TLDR
  def test_replace_middle
    Dir.mktmpdir do |dir|
      file = "#{dir}/test.txt"
      File.write(file, "A\nB\nC\nD\nE\n")

      result = Genie::ReplaceLinesInFile.new(base_path: dir).execute(
        filepath: file,
        start_line: 1,
        end_line: 3,
        content: "X\nY\n"
      )
      assert_equal true, result[:success]

      actual = File.read(file)
      expected = "A\nX\nY\nE\n"
      assert_equal expected, actual
    end
  end

  def test_replace_beginning
    Dir.mktmpdir do |dir|
      file = "#{dir}/test.txt"
      File.write(file, "Line1\nLine2\nLine3\n")

      result = Genie::ReplaceLinesInFile.new(base_path: dir).execute(
        filepath: file,
        start_line: 0,
        end_line: 0,
        content: "New1\n"
      )
      assert_equal true, result[:success]

      actual = File.read(file)
      expected = "New1\nLine2\nLine3\n"
      assert_equal expected, actual
    end
  end

  def test_replace_end
    Dir.mktmpdir do |dir|
      file = "#{dir}/test.txt"
      File.write(file, "1\n2\n3\n4\n")

      result = Genie::ReplaceLinesInFile.new(base_path: dir).execute(
        filepath: file,
        start_line: 3,
        end_line: 3,
        content: "End\n"
      )
      assert_equal true, result[:success]

      actual = File.read(file)
      expected = "1\n2\n3\nEnd\n"
      assert_equal expected, actual
    end
  end

  def test_replace_multiple_to_end
    Dir.mktmpdir do |dir|
      file = "#{dir}/test.txt"
      File.write(file, "A\nB\nC\nD\n")

      result = Genie::ReplaceLinesInFile.new(base_path: dir).execute(
        filepath: file,
        start_line: 2,
        end_line: 3,
        content: "X\n"
      )
      assert_equal true, result[:success]

      actual = File.read(file)
      expected = "A\nB\nX\n"
      assert_equal expected, actual
    end
  end

  def test_error_for_invalid_indices
    Dir.mktmpdir do |dir|
      file = "#{dir}/test.txt"
      File.write(file, "Only one line\n")

      # negative start
      result = Genie::ReplaceLinesInFile.new(base_path: dir).execute(
        filepath: file,
        start_line: -1,
        end_line: 0,
        content: "X\n"
      )
      assert result[:error]&.include?("Invalid line numbers"), "Expected error for negative start_line"

      # start > end
      result2 = Genie::ReplaceLinesInFile.new(base_path: dir).execute(
        filepath: file,
        start_line: 1,
        end_line: 0,
        content: "X\n"
      )
      assert result2[:error]&.include?("Invalid line numbers"), "Expected error for start_line > end_line"

      # end beyond last index
      result3 = Genie::ReplaceLinesInFile.new(base_path: dir).execute(
        filepath: file,
        start_line: 0,
        end_line: 5,
        content: "X\n"
      )
      assert result3[:error]&.include?("Invalid line numbers"), "Expected error for end_line beyond file"
    end
  end

  def test_error_for_file_outside_base_path
    Dir.mktmpdir do |dir|
      outside = "#{dir}/../outside.txt"

      result = Genie::ReplaceLinesInFile.new(base_path: dir).execute(
        filepath: outside,
        start_line: 0,
        end_line: 1,
        content: "data\n"
      )
      assert result[:error]&.include?("File not allowed"), "Expected error for file outside base path"
    end
  end

  def test_error_for_nonexistent_file
    Dir.mktmpdir do |dir|
      file = "#{dir}/no_file.txt"

      result = Genie::ReplaceLinesInFile.new(base_path: dir).execute(
        filepath: file,
        start_line: 0,
        end_line: 0,
        content: "data\n"
      )
      assert result[:error]&.include?("File not found"), "Expected error for nonexistent file"
    end
  end
end
