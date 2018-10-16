class RefreshController < ApplicationController
  # first authorize the request (CSRF etc.)
  before_action :authorize_refresh_by_access_request!
  # second authorize that the refresh token has not expired
  before_action :authorize_refresh_not_expired!

  def create

    session = JWTSessions::Session.new(payload: claimless_payload, refresh_by_access_allowed: true)

    tokens = session.refresh_by_access_payload do |refresh_token_uid, access_token_expiration|
      # this block only fires if the access token has not yet expired
      Rails.logger.warn "Malicious activity from #{current_user.email}.  Destroy their session."

      session.flush_by_access_payload

      response.delete_cookie JWTSessions.access_cookie

      # TODO: do we need to trigger an email

      raise JWTSessions::Errors::Unauthorized, 'Malicious activity detected'
    end

    response.set_cookie(
        JWTSessions.access_cookie,
        value: tokens[:access],
        httponly: true,
        secure: Rails.env.production?
    )

    render json: {csrf: tokens[:csrf]}, status: :created
  end

  private

  def authorize_refresh_not_expired!
    raise JWTSessions::Errors::Unauthorized, 'Session has expired' if Time.now > refresh_token_expiration
  end

  def refresh_token_expiration
    Time.at(JWTSessions::RefreshToken.find(claimless_payload['ruid'], JWTSessions.token_store).expiration.to_i)
  end
end
