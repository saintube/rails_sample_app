class CarsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def new
    @car = Car.new
  end

  def show
    @car = Car.find(params[:id])
  end

  def index
    @cars = Car.order("score desc").page(params[:page])
  end

  def create
    @car = Car.new(car_params)
    if @car.save
      flash[:success] = "车型已创建!"
      redirect_to @car
    else
      render 'new'
    end
  end

  def edit
    @car = Car.find(params[:id])
  end

  def destroy
  end

  private

    def car_params
      params.require(:car).permit(:carname, :description)
    end

end
