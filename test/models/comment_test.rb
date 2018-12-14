require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:michael)
    @car = cars(:regal)
    @comment = comments(:regal_comment)
  end
  
  test "user id should be present" do
    assert @user.valid?
  end
  
  test "car id should be present" do
    assert @car.valid?
  end
  
  test "should be valid" do
    assert @comment.valid?
  end
  
  test "content should be present" do
    @comment.content = "  "
    assert_not @comment.valid?
  end
  
  test "user should be exist" do
    @comment.user = nil
    assert_not @comment.valid?
  end
  
  test "car should be valid" do
    @comment.car = nil
    assert_not @comment.valid?
  end
  
  test "content should not be too long" do
    @comment.content = "w" * 65537
    assert_not @comment.valid?
  end

  test "order should be most recent first" do
    assert_equal comments(:most_recent), Comment.first
  end
    
end
