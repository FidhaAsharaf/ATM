class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  stale_when_importmap_changes

  protect_from_forgery with: :null_session

  helper_method :current_user
  before_action :authenticate_request!
  def authenticate_request!
    token =
      request.headers["Authorization"]&.split(" ")&.last ||
      params[:token] ||
      session[:access_token]

    if token.blank?
      return unauthorized_response
    end

    decoded = JsonWebToken.decode(token)
    @current_user = User.find_by(id: decoded[:user_id])

    if @current_user.nil?
      unauthorized_response
    end
  rescue JWT::DecodeError, JWT::ExpiredSignature
    unauthorized_response
  end

  def current_user
    @current_user
  end

  private

  def unauthorized_response
    respond_to do |format|
      format.html { redirect_to login_path, alert: "Please log in first" }
      format.json { render json: { error: "Unauthorized" }, status: :unauthorized }
    end
  end
end
