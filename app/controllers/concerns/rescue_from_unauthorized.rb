# frozen_string_literal: true

# Controller concern that rescues from JWTSessions::Errors::Unauthorized and produces
# a JSONAPI formatted error response with status 401.
module RescueFromUnauthorized
  extend ActiveSupport::Concern
  included do
    rescue_from JWTSessions::Errors::Unauthorized, with: :not_authorized

    private

    # JSONAPI friendly unauthorized (401) handler
    def not_authorized(exception)
      render json: {
        errors: [{
          code: :unauthorized,
          detail: exception.to_s,
          sources: {
            pointer: '/data/unauthorized'
          },
          status: :unauthorized,
          title: 'Not Authorized'
        }]
      }, status: :unauthorized
    end
  end
end
