class ApplicationController < ActionController::API
  include ActionController::MimeResponds

  include ActionController::ImplicitRender
  before_action :require_authorization_token

  private

  def require_authorization_token
    return if request.path == "/-/live"
    token = request.headers["Authorization"]&.split(" ")&.at(1)
    unless AuthToken.exists?(token: token)
      render json: {}, status: 401
    end
  end
end
