class ApplicationController < ActionController::API
  include JWTSessions::RailsAuthorization

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  rescue_from JWTSessions::Errors::Unauthorized, with: :not_authorized

  private

  # The current_user can be found in the JWT payload
  def current_user
    @current_user ||= User.find(payload['user_id'])
  end

  # JSONAPI friendly unauthorized (401) handler
  def not_authorized(exception)
    render json: {
      errors: [{
        code: :unauthorized,
        detail: exception.to_s,
        sources: {
          pointer: '/data'
        },
        status: :unauthorized,
        title: 'Not Authorized',
      }]
    }, status: :unauthorized
  end

  # JSONAPI friendly not found (404) handler
  def not_found(exception)
    render json: {
      errors: [{
        code: JSONAPI::RECORD_NOT_FOUND,
        detail: exception.to_s,
        sources: {
          pointer: '/data'
        },
        status: JSONAPI::RECORD_NOT_FOUND,
        title: 'Not Found',
      }]
    }, status: :not_found
  end
end
