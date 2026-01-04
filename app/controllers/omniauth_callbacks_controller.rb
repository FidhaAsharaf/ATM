# # class OmniauthCallbacksController < ApplicationController
# #   skip_before_action :verify_authenticity_token

# #   def google
# #     auth = request.env["omniauth.auth"]

# #     user = User.find_or_initialize_by(
# #       email: auth.info.email
# #     )

# #     if user.new_record?
# #       user.provider = auth.provider
# #       user.uid = auth.uid
# #       user.password = SecureRandom.hex(20)
# #       user.save!
# #     end

# #     token = JsonWebToken.encode(user_id: user.id)


# #     # redirect_to welcome_path(token: token)
# #     response = {
# #       access_token: token,
# #       user: {
# #         id: user.id,
# #         email: user.email
# #       }
# #     }

# #     Rails.logger.info response.to_json
# #     session[:access_token] = token
# #     redirect_to welcome_path
# #   end
# # end

# class OmniauthCallbacksController < ApplicationController
#   skip_before_action :verify_authenticity_token

#   def google
#     auth = request.env["omniauth.auth"]

#     # ONLY find existing user
#     user = User.find_by(email: auth.info.email)

#     # 🚫 If user does NOT exist → block Google login
#     if user.nil?
#       redirect_to signup_path,
#         alert: "No account found with this Google email. Please create an account first."
#       return
#     end

#     # Optional: ensure this user was registered with Google
#     if user.provider.present? && user.provider != auth.provider
#       redirect_to login_path,
#         alert: "This email is registered using password login."
#       return
#     end

#     # Generate JWT token
#     token = JsonWebToken.encode(user_id: user.id)

#     session[:access_token] = token

#     redirect_to welcome_path, notice: "Logged in successfully with Google"
#   end
# end
class OmniauthCallbacksController < ApplicationController
  # Google callback must be public
  skip_before_action :authenticate_request!

  def google
    auth = request.env["omniauth.auth"]

    # ✅ ONLY find existing user
    user = User.find_by(email: auth.info.email)

    # 🚫 BLOCK new users
    if user.nil?
      redirect_to signup_path,
        alert: "No account found with this Google email. Please create an account first."
      return
    end

    # Optional safety check
    if user.provider.present? && user.provider != auth.provider
      redirect_to login_path,
        alert: "This account was created using email & password."
      return
    end

    # ✅ Generate JWT for existing user
    token = JsonWebToken.encode(user_id: user.id)

    session[:access_token] = token
    session[:user_id] = user.id

    redirect_to welcome_path, notice: "Logged in successfully with Google"
  end
end
