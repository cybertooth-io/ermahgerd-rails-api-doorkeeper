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
  include RescueFromForbidden
  include RescueFromRecordNotFound
  include RescueFromUnauthorized
end
