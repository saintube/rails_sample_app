require 'test_helper'

class CommentTest < ActiveSupport::TestCase

  def setup
    @comment = Comment.new(content_id: 2, content: "It's a nice car but costs too much!", subject_value: -1, sentiment_value: 0)
  end

  test "should be valid" do
    assert @comment.valid?
  end

  test "content and content_id should be present" do
    @comment.content_id = nil
    assert_not @comment.valid?
    @comment.content_id = 2
    @comment.content = "    "
    assert_not @comment.valid?
  end

end
