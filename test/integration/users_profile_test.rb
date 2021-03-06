require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:michael)
    ApplicationController.class_eval do
      define_method :verify_rucaptcha? do |captcha|
        true
      end
    end
  end

  test "profile display" do
    log_in_as(@user)
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'h1>img.gravatar'
    assert_match @user.comments.count.to_s, response.body
    assert_select 'ul.pagination'
    @user.comments.page(1).per(5).each do |comment|
      assert_match comment.content, response.body
    end
  end
end
