class OmniauthCallbacksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def google
    auth = request.env["omniauth.auth"]

    user = User.find_or_initialize_by(
      email: auth.info.email
    )

    if user.new_record?
      user.provider = auth.provider
      user.uid = auth.uid
      user.password = SecureRandom.hex(20)
      user.save!
    end

    token = JsonWebToken.encode(user_id: user.id)


    # redirect_to welcome_path(token: token)
    response = {
      access_token: token,
      user: {
        id: user.id,
        email: user.email
      }
    }

    Rails.logger.info response.to_json
    session[:access_token] = token
    redirect_to welcome_path
  end
end
