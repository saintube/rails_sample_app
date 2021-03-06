class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.order(:id).page(params[:page])
  end

  def show
    @user = User.find(params[:id])
    @comments = @user.comments.page(params[:page]).per(5)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if verify_rucaptcha?(@use) && @user.save
      log_in @user
      flash[:success] = "欢迎来到汽车在线论坛"
      redirect_to user_url(@user)
    else
      @user.errors.add(:base, t('rucaptcha.invalid'))
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if verify_rucaptcha?(@user) && @user.update_attributes(user_params)
      flash[:success] = "个人资料已更新"
      redirect_to @user
    else
      @user.errors.add(:base, t('rucaptcha.invalid'))
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "用户已删除"
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # 前置过滤器

end
