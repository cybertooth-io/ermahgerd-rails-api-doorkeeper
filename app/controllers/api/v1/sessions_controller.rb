# frozen_string_literal: true

module Api
  module V1
    # Simple JSONAPI controller that offers up all the basic actions.
    # This instance is special because it's `SessionsResource` is set to immutable so only read-only access
    # to the Session model will be provided through this controller.
    #
    # An `invalidate` action has been added to this controller.  This allows sessions to be destroyed
    # application-side for security reasons.
    class SessionsController < BaseJsonapiResourcesController
      def invalidate
        session = Session.find_by!(id: params[:id])

        authorize session # pundit authorization

        jwt_session = JWTSessions::Session.new(payload: payload)

        begin
          jwt_session.flush_by_uid(session.ruid)

          render json: { data: {}, meta: {} }, status: :no_content
        rescue JWTSessions::Errors::Unauthorized => exception

          not_found exception

        ensure

          session.update!(invalidated: true, invalidated_by: current_user)

        end
      end
    end
  end
end
