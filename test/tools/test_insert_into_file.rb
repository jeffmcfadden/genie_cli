require "tmpdir"

class TestInsertIntoFile < TLDR
  def test_insert_at_middle
    Dir.mktmpdir do |dir|
      file = "#{dir}/test.txt"
      # Create initial content
      File.write(file, "A\nB\nC\n")

      result = Genie::InsertIntoFile.new(base_path: dir).execute(
        filepath: file,
        content: "X\n",
        line_number: 2
      )
      assert_equal true, result[:success]

      actual = File.read(file)
      expected = "A\nX\nB\nC\n"
      assert_equal expected, actual
    end
  end

  def test_insert_at_beginning
    Dir.mktmpdir do |dir|
      file = "#{dir}/test.txt"
      File.write(file, "Line1\nLine2\n")

      result = Genie::InsertIntoFile.new(base_path: dir).execute(
        filepath: file,
        content: "New\n",
        line_number: 1
      )
      assert_equal true, result[:success]
      actual = File.read(file)
      expected = "New\nLine1\nLine2\n"
      assert_equal expected, actual
    end
  end

  def test_insert_at_end
    Dir.mktmpdir do |dir|
      file = "#{dir}/test.txt"
      File.write(file, "1\n2\n3\n")

      # Append by specifying line_number one past last line
      result = Genie::InsertIntoFile.new(base_path: dir).execute(
        filepath: file,
        content: "4\n",
        line_number: 4
      )
      assert_equal true, result[:success]
      actual = File.read(file)
      expected = "1\n2\n3\n4\n"
      assert_equal expected, actual
    end
  end

  def test_error_for_invalid_line_number
    Dir.mktmpdir do |dir|
      file = "#{dir}/test.txt"
      File.write(file, "Only one line\n")

      result = Genie::InsertIntoFile.new(base_path: dir).execute(
        filepath: file,
        content: "Oops\n",
        line_number: 0
      )
      assert result[:error]&.include?("Invalid line number"), "Expected error for invalid line number"
    end
  end

  def test_error_for_file_outside_base_path
    Dir.mktmpdir do |dir|
      outside = "#{dir}/../outside.txt"

      result = Genie::InsertIntoFile.new(base_path: dir).execute(
        filepath: outside,
        content: "data\n",
        line_number: 1
      )
      assert result[:error]&.include?("File not allowed"), "Expected error for file outside base path"
    end
  end

  def test_error_for_nonexistent_file
    Dir.mktmpdir do |dir|
      file = "#{dir}/no_file.txt"

      result = Genie::InsertIntoFile.new(base_path: dir).execute(
        filepath: file,
        content: "data\n",
        line_number: 1
      )
      assert result[:error]&.include?("File not found"), "Expected error for nonexistent file"
    end
  end
end