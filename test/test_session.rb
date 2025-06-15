require_relative "test_helper"

class SessionTest < TLDR
  def test_initialize_sets_base_path
    base = "/path/to/project"
    session = TDD::Session.new(base_path: base)
    assert_equal base, session.base_path
  end

  def test_base_path_is_read_only
    session = TDD::Session.new(base_path: "/foo")
    assert_raises(NoMethodError) do
      session.base_path = "/bar"
    end
  end

  def test_missing_base_path_raises
    assert_raises(ArgumentError) do
      TDD::Session.new
    end
  end
end
