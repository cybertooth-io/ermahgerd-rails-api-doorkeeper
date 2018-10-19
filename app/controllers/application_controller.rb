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
        title: 'Not Authorized'
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
        title: 'Not Found'
      }]
    }, status: :not_found
  end
end
