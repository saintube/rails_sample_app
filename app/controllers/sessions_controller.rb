class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && verify_rucaptcha?(user) && user.authenticate(params[:session][:password])
      log_in user
      redirect_back_or user
    else
      flash.now[:danger] = 'Invalid email/password combination or invalid captcha code'
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
