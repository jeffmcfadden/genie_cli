require "tmpdir"

class TestRenameFile < TLDR
  def test_rename_success
    Dir.mktmpdir do |dir|
      src = "#{dir}/old.txt"
      dst = "#{dir}/new.txt"
      content = "Hello"
      File.write(src, content)

      result = TDD::RenameFile.new(base_path: dir).execute(
        filepath: src,
        new_path: dst
      )
      assert_equal true, result[:success]

      # Source should no longer exist, target should exist with content preserved
      assert !File.exist?(src), "Expected source file to be removed"
      assert File.exist?(dst), "Expected target file to exist"
      assert_equal content, File.read(dst)
    end
  end

  def test_error_for_source_outside_base_path
    Dir.mktmpdir do |dir|
      outside = "#{dir}/../outside.txt"
      result = TDD::RenameFile.new(base_path: dir).execute(
        filepath: outside,
        new_path: "#{dir}/new.txt"
      )
      assert result[:error]&.include?("File not allowed"), "Expected error for source outside base path"
    end
  end

  def test_error_for_destination_outside_base_path
    Dir.mktmpdir do |dir|
      src = "#{dir}/file.txt"
      File.write(src, "data")
      outside_dst = "#{dir}/../new.txt"
      result = TDD::RenameFile.new(base_path: dir).execute(
        filepath: src,
        new_path: outside_dst
      )
      assert result[:error]&.include?("Destination not allowed"), "Expected error for destination outside base path"
    end
  end

  def test_error_for_nonexistent_source_file
    Dir.mktmpdir do |dir|
      src = "#{dir}/no_file.txt"
      dst = "#{dir}/new.txt"
      result = TDD::RenameFile.new(base_path: dir).execute(
        filepath: src,
        new_path: dst
      )
      assert result[:error]&.include?("File not found"), "Expected error for nonexistent source file"
    end
  end

  def test_error_for_existing_destination_file
    Dir.mktmpdir do |dir|
      src = "#{dir}/a.txt"
      dst = "#{dir}/b.txt"
      File.write(src, "A")
      File.write(dst, "B")

      result = TDD::RenameFile.new(base_path: dir).execute(
        filepath: src,
        new_path: dst
      )
      assert result[:error]&.include?("Destination already exists"), "Expected error for existing destination file"
    end
  end
end
