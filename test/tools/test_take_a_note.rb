
require "test_helper"

class TestTakeANote < TLDR

  def test_take_a_note
    tool = Genie::Tools::TakeANote.new
    response = tool.run(note: "This is a test note.")
    assert_equal({ success: true, note: "This is a test note." }, response)
  end
end
