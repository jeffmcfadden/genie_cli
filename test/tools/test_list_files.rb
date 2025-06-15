require "tools/list_files"

class TestListFiles < TLDR
  def test_list_files
    actual = TDD::ListFiles.new.execute(directory: "./test/data/sample_files")

    expected = [{ name: "one.txt", type: "file" }, { name: "a_dir", type: "directory" }]

    assert_equal expected, actual
  end
end