class RefreshController < ApplicationController
  before_action :authorize_refresh_by_access_request!

  def create

    session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
    tokens = session.refresh_by_access_payload

    response.set_cookie(
      JWTSessions.access_cookie,
      value: tokens[:access],
      httponly: true,
      secure: Rails.env.production?
    )

    render json: { csrf: tokens[:csrf] }, status: :created
  end

  def access_payload
    # payload here stands for refresh token payload
    build_access_payload_based_on_refresh(payload)
  end
end
