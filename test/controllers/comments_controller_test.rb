require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @car = cars(:regal)
    @comment = comments(:regal_comment)
    ApplicationController.class_eval do
      define_method :verify_rucaptcha? do |captcha|
        true
      end
    end
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Comment.count' do
      post comments_path, params: { comment: { content: "test content", user: @user, car: @car } }
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Comment.count' do
      delete comment_path(@comment)
    end
    assert_redirected_to login_url
  end

end
