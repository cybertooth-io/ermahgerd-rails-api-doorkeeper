# frozen_string_literal: true

# Controller that all generated Controller inherit from.
# Includes `JWTSessions::RailsAuthorization` which will provide very helpful hook methods such as
# `:authorize_access_request!` and `:authorize_refresh_by_access_request!`.
# This controller is configured to rescue from the following errors:
# 1. ActiveRecord::RecordNotFound - that way you can Model.find_by! and have the controller handle the error
# 2. JWTSessions::Errors::Unauthorized - any unauthorized access comes here for processing
#
# Errors will be serialized to match the JSONAPI specification: https://jsonapi.org/format/#document-top-level &
# https://jsonapi.org/format/#errors
#
# The `current_user` method will get a reference to the authenticated `User` instance.
class ApplicationController < ActionController::API
  include JWTSessions::RailsAuthorization

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  rescue_from JWTSessions::Errors::Unauthorized, with: :not_authorized

  rescue_from Pundit::NotAuthorizedError, with: :forbidden

  private

  # The current_user can be found in the JWT payload; eagerly load the user's roles so they can be discriminated
  # against
  def current_user
    @current_user ||= User.includes(:roles).find_by(id: payload['user_id'])
  end

  # JSONAPI friendly not found (404) handler
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
