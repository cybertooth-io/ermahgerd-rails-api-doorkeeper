class Api::V1::Protected::SessionsController < ApplicationController
  include JSONAPI::ActsAsResourceController
  # TODO: make JSONAPI resource immutable
  before_action :authorize_access_request!

  def invalidate
    # TODO: protect this action using Pundit so that only Administrator role can do it
    session = Session.find_by!(id: params[:id])

    jwt_session = JWTSessions::Session.new(payload: payload)
    # TODO: the following flush will throw an JWTSessions::Errors::Unauthorized exception if the refresh token
    # cannot be found; what should we do?
    jwt_session.flush_by_uid(session.ruid)
    Session.update(invalidated: true, invalidated_by: current_user)

    render json: {data: {}, meta: {}}, status: :no_content
  end

end
