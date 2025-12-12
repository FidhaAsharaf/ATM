class SessionsController < ApplicationController
  def new
  end

  def create
    @entered_email = params[:email]      # preserve email input
    user = User.find_by(email: @entered_email)

    if user.nil?
      @email_error = "No account found with this email"
      render :new

    elsif !user.authenticate(params[:password])
      @password_error = "Incorrect password"
      render :new

    else
      session[:user_id] = user.id
      redirect_to welcome_path, notice: "Logged in successfully!"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: "Logged out!"
  end
end
