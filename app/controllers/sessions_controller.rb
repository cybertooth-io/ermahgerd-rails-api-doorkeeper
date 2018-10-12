class SessionsController < ApplicationController
  before_action :authorize_access_request!, only: [:destroy]

  # login
  def create
    user = User.find_by!(email: params[:email])

    if user.authenticate(params[:password])

      payload = { user_id: user.id }
      session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
      tokens = session.login

      response.set_cookie(
        JWTSessions.access_cookie,
        value: tokens[:access],
        httponly: true,
        secure: Rails.env.production?
      )

      # TODO: what do we do with the REFRESH token?  It is in Redis and is being accessed by JwtSession's Session class

      render json: { csrf: tokens[:csrf] }, status: :created

    else

      raise JWTSessions::Errors::Unauthorized, 'Authentication failed'

    end
  end

  # logout
  def destroy
    session = JWTSessions::Session.new(payload: payload)
    session.flush_by_access_payload

    response.delete_cookie JWTSessions.access_cookie

    render json: { data: {}, meta: {} }, status: :no_content
  end
end
