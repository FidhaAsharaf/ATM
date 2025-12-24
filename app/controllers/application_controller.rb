class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  protect_from_forgery with: :null_session


  def authenticate_request!
    token =
      request.headers["Authorization"]&.split(" ")&.last ||
      params[:token] ||
      session[:access_token]

    decoded = JsonWebToken.decode(token)
    @current_user = User.find(decoded[:user_id])
  rescue
    render json: { error: "Unauthorized" }, status: :unauthorized
  end
end
