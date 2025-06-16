
require "test_helper"

class TestTakeANote < TLDR

  def test_take_a_note
    tool = Genie::TakeANote.new
    response = tool.execute(note: "This is a test note.")
    assert_equal({ note: "This is a test note." }, response)
  end
end
