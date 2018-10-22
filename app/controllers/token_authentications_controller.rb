# frozen_string_literal: true

# Provides the means to authenticate and be issued the encrypted access token.  It is
# expected that you will provide the access token with every request for protected resources.
#
# The access token will eventually expire and need to be re-issued in partnership with the associated refresh
# token that remains guarded on the server side.
#
# Session information is collected during login.  This is mostly pulled from the User-Agent header.  But it
# is important to note that the RUID to the refresh token stored in Redis is recorded to the `Session`.  Doing this
# allows a session to be identified and potentially invalidated by the owning user or administrators.
class TokenAuthenticationsController < ApplicationController
  before_action :authorize_access_request!, only: [:destroy]

  # login
  def create
    user = User.find_by!(email: params[:email])

    raise JWTSessions::Errors::Unauthorized, 'Authentication failed' unless user.authenticate(params[:password])

    # got here, means authentication was sucessful

    payload = { user_id: user.id }
    session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
    tokens = session.login

    # record session information in the database for administrative use
    browser = Browser.new(request.headers['User-Agent'])
    Session.create!(
      browser: browser.name,
      browser_version: browser.full_version,
      device: browser.device.name,
      expiring_at: tokens[:refresh_expires_at],
      ip_address: request.remote_ip,
      platform: browser.platform.name,
      platform_version: browser.platform.version,
      ruid: session.payload['ruid'],
      user: user
    )

    render json: { access: tokens[:access] }, status: :created
  end

  # logout
  def destroy
    jwt_session = JWTSessions::Session.new(payload: payload)
    jwt_session.flush_by_access_payload

    Session.find_by(ruid: payload['ruid']).update!(invalidated: true, invalidated_by: current_user)

    render json: { data: {}, meta: {} }, status: :no_content
  end
end
