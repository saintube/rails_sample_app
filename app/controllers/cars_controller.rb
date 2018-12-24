class CarsController < ApplicationController
  before_action :logged_in_user, only: [:create, :edit, :update, :destroy]
  before_action :admin_user, only: [:edit, :update, :destroy]

  def new
    @car = Car.new
  end

  def show
    @car = Car.find(params[:id])
    @comment = current_user.comments.build if logged_in?
    @comments = @car.comments.page(params[:page]).per(5)
  end

  def index
    @cars = Car.order("score desc").page(params[:page])
  end

  def create
    @car = Car.new(car_params)
    @car.score = 50
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

  def update
    @car = Car.find(params[:id])
    if @car.update_attributes(car_params)
      flash[:success] = "车型已更新"
      redirect_to @car
    else
      render 'edit'
    end
  end

  def destroy
    Car.find(params[:id]).destroy
    flash[:success] = "车型已删除"
    redirect_to cars_url
  end

  private

    def car_params
      params.require(:car).permit(:carname, :description)
    end

end
