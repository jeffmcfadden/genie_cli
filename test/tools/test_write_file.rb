require "tmpdir"

require "tools/write_file"

class TestWriteFile < TLDR
  def test_write_file
    Dir.mktmpdir {|dir|

      Genie::WriteFile.new(base_path: "#{dir}").execute(filepath: "#{dir}/test_file.txt", content: "Hello, World!")

      actual = File.read("#{dir}/test_file.txt")
      expected = "Hello, World!"

      assert_equal expected, actual
    }
  end
end