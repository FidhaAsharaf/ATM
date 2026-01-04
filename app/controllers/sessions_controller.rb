class SessionsController < ApplicationController
  skip_before_action :authenticate_request!, only: [ :new, :create ]

  def new
  end

  def create
    @entered_email = params[:email]
    user = User.find_by(email: @entered_email)

    if user.nil?
      @email_error = "No account found with this email"
      render :new, status: :unprocessable_entity

    elsif !user.authenticate(params[:password])
      @password_error = "Incorrect password"
      render :new, status: :unprocessable_entity

    else
      token = JsonWebToken.encode(user_id: user.id)

      session[:access_token] = token
      session[:user_id] = user.id

      redirect_to welcome_path, notice: "Logged in successfully!"
    end
  end

  def destroy
    session[:user_id] = nil
    session[:access_token] = nil
    redirect_to login_path, notice: "Logged out!"
  end
end
