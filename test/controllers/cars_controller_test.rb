require 'test_helper'

class CarsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
    @car = cars(:regal)
    ApplicationController.class_eval do
      define_method :verify_rucaptcha? do |captcha|
        true
      end
    end
  end

  test "should get new" do
    get cars_new_url
    assert_response :success
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Car.count' do
      delete car_path(@car)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'Car.count' do
      delete car_path(@car)
    end
    assert_redirected_to root_url
  end

  test "should destroy when logged in as an admin" do
    log_in_as(@user)
    assert_difference 'Car.count', -1 do
      delete car_path(@car)
    end
    assert_redirected_to cars_url
  end
end
