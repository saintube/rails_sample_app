require 'test_helper'

class CarsCreateTest < ActionDispatch::IntegrationTest

  def setup
    ApplicationController.class_eval do
      define_method :verify_rucaptcha? do |captcha|
        true
      end
    end
  end

  test "invalid car information" do
    log_in_as(users(:michael))
    get new_car_path
    assert_no_difference 'Car.count' do
      post new_car_path, params: { car: { carname: " ", description: "xxx" } }
    end
    assert_template 'cars/new'
  end

  test "valid signup information" do
    log_in_as(users(:michael))
    get new_car_path
    assert_difference 'Car.count', 1 do
      post new_car_path, params: { car: { carname: "Cartest", description: "xxx" } }
    end
    follow_redirect!
    assert_template 'cars/show'
  end

end
