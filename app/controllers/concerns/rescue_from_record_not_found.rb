# frozen_string_literal: true

# Controller concern that rescues from ActiveRecord::RecordNotFound and produces
# a JSONAPI formatted error response with status 404.
module RescueFromRecordNotFound
  extend ActiveSupport::Concern
  included do
    rescue_from ActiveRecord::RecordNotFound, with: :not_found

    private

    # JSONAPI friendly not found (404) handler
    def not_found(exception)
      render json: {
        errors: [{
          code: JSONAPI::RECORD_NOT_FOUND,
          detail: exception.to_s,
          sources: {
            pointer: '/data/base'
          },
          status: JSONAPI::RECORD_NOT_FOUND,
          title: 'Not Found'
        }]
      }, status: :not_found
    end
  end
end
