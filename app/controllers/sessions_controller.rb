class SessionsController < ApplicationController
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

      response.set_cookie(
        JWTSessions.refresh_cookie,
        value: tokens[:refresh],
        httponly: true,
        secure: Rails.env.production?
      )

      render json: { csrf: tokens[:csrf] }, status: :created

    else

      raise JWTSessions::Errors::Unauthorized, 'Authentication failed'

    end
  end
end
