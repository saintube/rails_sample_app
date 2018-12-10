require 'test_helper'

class CarTest < ActiveSupport::TestCase

  def setup
    @car = Car.new(carname: "Regal", description: "Buick Regal", subjects: nil, score: 80)
  end

  test "should be valid" do
    assert @car.valid?
  end

  test "carname should be present" do
    @car.carname = "  "
    assert_not @car.valid?
  end

  test "carname should be unique" do
    duplicate_car = @car.dup
    @car.save
    assert_not duplicate_car.valid?
  end

end
