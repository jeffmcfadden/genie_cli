require "tmpdir"

require "tools/append_to_file"

class TestAppendToFile < TLDR
  def test_append_to_existing_file
    Dir.mktmpdir do |dir|
      file = "#{dir}/test_file.txt"
      # Create initial content
      File.write(file, "Hello\n")

      result = Genie::AppendToFile.new(base_path: dir).execute(filepath: file, content: "World\n")
      assert_equal true, result[:success]

      actual = File.read(file)
      expected = "Hello\nWorld\n"
      assert_equal expected, actual
    end
  end

  def test_error_for_file_outside_base_path
    Dir.mktmpdir do |dir|
      outside = "#{dir}/../outside.txt"

      result = Genie::AppendToFile.new(base_path: dir).execute(filepath: outside, content: "data")
      assert result[:error]&.include?("File not allowed"), "Expected error for file outside base path"
    end
  end
end