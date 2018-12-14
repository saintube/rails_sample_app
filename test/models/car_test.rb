require 'test_helper'

class CarTest < ActiveSupport::TestCase

  def setup
    #@car = Car.new(carname: "Regal", description: "Buick Regal", subjects: nil, score: 80)
    @car = cars(:regal)
    @other_car = cars(:b520i)
  end

  test "should be valid" do
    assert @car.valid?
    assert @other_car.valid?
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

  test "carname should not be too short" do
    @car.carname = "c"
    assert_not @car.valid?
  end

  test "carname should not be too long" do
    @car.carname = "c" * 33
    assert_not @car.valid?
  end

  test "carname validation should reject invalid carname" do
    @car.carname = "123car"
    assert_not @car.valid?
  end

  test "description should not be too long" do
    @car.description = "d" * 257
    assert_not @car.valid?
  end

end
