# frozen_string_literal: true

# This controller is responsible for refreshing access tokens that are being passed in the request header
# and that have expired.  A refresh token is not required.
#
# JWTSessions does not appear to respect RefreshToken expiry in its workflow, so it is up to this
# implementation to `:authorize_refresh_not_expired!`.  Should a refresh token hit its expiry, we
# will actually send back a 401 UNAUTHORIZED with the message 'Session has expired'.
#
# Otherwise, we will attempt to refresh the access token so that it can continue accessing resources.  Attempts
# to refresh an access token prior to its expiry will be flush the session and produce a 401 UNAUTHORIZED response
# that will describe the refresh attempt as 'Malicious activity detected'.
class RefreshTokensController < ApplicationController
  include CurrentUser
  include JWTSessions::RailsAuthorization

  # first authorize the request (CSRF etc.)
  before_action :authorize_refresh_by_access_request!
  # second authorize that the refresh token has not expired
  before_action :authorize_refresh_not_expired!

  def create
    session = JWTSessions::Session.new(payload: claimless_payload, refresh_by_access_allowed: true)

    tokens = session.refresh_by_access_payload do |_refresh_token_uid, _access_token_expiration|
      # this block only fires if the access token has not yet expired
      Rails.logger.warn "Malicious activity from #{current_user.email}.  Destroy their session."

      session.flush_by_access_payload

      # TODO: do we need to trigger an email to inform of malicious activity? See #22

      raise JWTSessions::Errors::Unauthorized, 'Malicious activity detected'
    end

    render json: { access: tokens[:access] }, status: :created
  end

  private

  def authorize_refresh_not_expired!
    raise JWTSessions::Errors::Unauthorized, 'Session has expired' if Time.now.to_i > refresh_token_expiration
  end

  def refresh_token_expiration
    JWTSessions::RefreshToken.find(claimless_payload['ruid'], JWTSessions.token_store).expiration.to_i
  end
end
