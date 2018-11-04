# frozen_string_literal: true

require 'browser'

# Provides the means to authenticate and store the access token in a secure HTTP cookie that the
# client/caller cannot bugger with.
#
# A CSRF token is returned from a successful authentication interaction and will be required for all
# DELETE/PATCH/PUT actions going forward while authentication is stored in the HTTP cookie.
#
# The access token stored in the cookie will eventually expire and need to be re-issued in
# partnership with the associated refresh token that remains guarded on the server side.
#
# Session information is collected during login.  This is mostly pulled from the User-Agent header.  But it
# is important to note that the RUID to the refresh token stored in Redis is recorded to the `Session`.  Doing this
# allows a session to be identified and potentially invalidated by the owning user or administrators.
class CookieAuthenticationsController < ApplicationController
  include CurrentUser
  include JWTSessions::RailsAuthorization

  before_action :authorize_access_request!, only: [:destroy]

  # login
  def create
    user = User.find_by!(email: params[:email])

    raise JWTSessions::Errors::Unauthorized, 'Authentication failed' unless user.authenticate(params[:password])

    # got here, means authentication was sucessful

    payload = { user_id: user.id }
    session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
    tokens = session.login

    response.set_cookie(
      JWTSessions.access_cookie,
      value: tokens[:access],
      httponly: true,
      path: '/',
      secure: Rails.env.production?
    )

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

    render json: { csrf: tokens[:csrf] }, status: :created
  end

  # logout
  def destroy
    jwt_session = JWTSessions::Session.new(payload: payload)
    jwt_session.flush_by_access_payload

    response.delete_cookie JWTSessions.access_cookie

    Session.find_by(ruid: payload['ruid']).update!(invalidated: true, invalidated_by: current_user)

    render json: { data: {}, meta: {} }, status: :no_content
  end
end
