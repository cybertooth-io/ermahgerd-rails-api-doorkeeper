# frozen_string_literal: true

# Controller concern that rescues from Pundit::NotAuthorizedError and produces
# a JSONAPI formatted error response with status 403.
module RescueFromForbidden
  extend ActiveSupport::Concern
  included do
    rescue_from Pundit::NotAuthorizedError, with: :forbidden

    private

    # JSONAPI friendly not found (403) handler
    def forbidden(exception)
      # can improve these messages by simply adding to the translations bundle
      # see https://github.com/varvet/pundit#creating-custom-error-messages
      render json: {
        errors: [{
          code: JSONAPI::FORBIDDEN,
          detail: I18n.t(
            "#{exception.policy.class.to_s.underscore}.#{exception.query}", scope: 'pundit', default: :default
          ),
          sources: {
            pointer: '/data/forbidden'
          },
          status: JSONAPI::FORBIDDEN,
          title: 'Forbidden'
        }]
      }, status: :forbidden
    end
  end
end
