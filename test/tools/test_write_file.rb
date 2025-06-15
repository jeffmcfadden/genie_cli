require "tmpdir"

require "tools/write_file"

class TestWriteFile < TLDR
  def test_write_file
    Dir.mktmpdir {|dir|

      TDD::WriteFile.new.execute(filepath: "#{dir}/test_file.txt", content: "Hello, World!")

      actual = File.read("#{dir}/test_file.txt")
      expected = "Hello, World!"

      assert_equal expected, actual
    }
  end
end