require 'browser'

class AuthenticationsController < ApplicationController
  before_action :authorize_access_request!, only: [:destroy]

  # login
  def create
    user = User.find_by!(email: params[:email])

    if user.authenticate(params[:password])

      payload = {user_id: user.id}
      session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
      tokens = session.login

      response.set_cookie(
          JWTSessions.access_cookie,
          value: tokens[:access],
          httponly: true,
          secure: Rails.env.production?
      )

      # record session information in the database for administrative use
      browser = Browser.new(request.headers['User-Agent'])
      Session.create!(
          browser: browser.name,
          browser_version: browser.full_version,
          device: browser.device.name,
          expiring_at: Time.now, # TODO: must pull this from the refresh token
          ip_address: request.remote_ip,
          platform: browser.platform.name,
          platform_version: browser.platform.version,
          ruid: session.payload['ruid'],
          user: user
      )

      render json: {csrf: tokens[:csrf]}, status: :created

    else

      raise JWTSessions::Errors::Unauthorized, 'Authentication failed'

    end
  end

  # logout
  def destroy
    session = JWTSessions::Session.new(payload: payload)
    session.flush_by_access_payload

    response.delete_cookie JWTSessions.access_cookie
    # TODO update SessionsUser

    render json: {data: {}, meta: {}}, status: :no_content
  end
end
