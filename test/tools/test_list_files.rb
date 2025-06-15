require "tools/list_files"

class TestListFiles < TLDR
  def test_list_files
    actual = TDD::ListFiles.new(base_path: File.expand_path("../../", __dir__)).execute(directory: "./test/data/sample_files")

    expected = [{ name: "read_file_test.txt", type: "file" },
                { name: "one.txt", type: "file" },
                { name: "a_dir", type: "directory" }]

    assert_equal expected, actual
  end

  def test_list_files_in_invalid_directory
    actual = TDD::ListFiles.new(base_path: "/tmp").execute(directory: "/blah/nothing/data/invalid_dir")

    expected = { error: "Directory not allowed: /blah/nothing/data/invalid_dir. Must be within base path: /tmp" }

    assert_equal expected, actual
  end

  def test_list_files_with_filter
    base_path = File.expand_path("../../", __dir__)
    t = TDD::ListFiles.new(base_path: base_path)
    actual = t.execute(directory: "./test/data/sample_files", filter: "one")

    expected = [{ name: "one.txt", type: "file" }]

    assert_equal expected, actual
  end
end
