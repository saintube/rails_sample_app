require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    ApplicationController.class_eval do
      define_method :verify_rucaptcha? do |captcha|
        true
      end
    end
  end

  test "layout links before login" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", signup_path
    get contact_path
    assert_select "title", full_title("联系我们")
  end

  test "layout links after login" do
    log_in_as(@user)
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", signup_path, count: 0
  end

end
