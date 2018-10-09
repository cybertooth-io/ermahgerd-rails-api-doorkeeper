class ApplicationController < ActionController::API
  include JWTSessions::RailsAuthorization

  rescue_from JWTSessions::Errors::Unauthorized, with: :not_authorized

  private

  def not_authorized(exception)
    render json: { errors: [{
      code: :unauthorized,
      detail: exception.to_s,
      sources: {
        pointer: '/data'
      },
      status: :unauthorized,
      title: 'Not Authorized',
    }] }, status: :unauthorized
  end
end
