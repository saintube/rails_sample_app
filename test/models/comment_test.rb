require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
    @car = Car.new(carname: "Regal", description: "Buick Regal", subjects: nil, score: 80)
    @comment = Comment.new(content: "this car is great", subjects_value: nil, sentiment_value: 80, user: @user, car: @car)
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
    
end
