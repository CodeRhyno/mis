class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
  end

  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      if user.can_access?
        session[:user_id] = user.id
        user.update(last_login_at: Time.current)
        redirect_to root_path, notice: 'Logged in successfully'
      else
        redirect_to login_path, alert: 'Your account has been suspended'
      end
    else
      flash.now[:alert] = 'Invalid email or password'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: 'Logged out successfully'
  end
end
