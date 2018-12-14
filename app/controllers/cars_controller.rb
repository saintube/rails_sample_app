class CarsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def new
    @car = Car.new
  end

  def create
    @car = current_user.cars.build(car_params)
    if @car.save
      flash[:success] = "车型已创建!"
      redirected_to root_url
    else
      render 'static_pages/home'
    end
  end

  def destroy
  end

  private

    def car_params
      params.require(:car).permit(:carname, :description)
    end

end
