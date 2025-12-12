class OmniauthCallbacksController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :google
  def google
    auth = request.env["omniauth.auth"]

    # Extract email from Google
    email = auth.info.email

    # Find or create the user
    user = User.find_or_initialize_by(email: email)

    # Create user if new (password not needed)
    if user.new_record?
      user.password = SecureRandom.hex(10) # random password
      user.save
    end

    session[:user_id] = user.id
    redirect_to welcome_path, notice: "Signed in with Google!"
  end
end
