# frozen_string_literal: true

module Api
  module V1
    # This is a JSONAPI-Resources ready controller that tests authentication using JWTSessions and tests
    # authorization using Pundit policies.
    class BaseJsonapiResourcesController < ApplicationController
      include CurrentUser
      # TODO: for Doorkeeper
      # include Doorkeeper::Rails::Helpers
      include JSONAPI::ActsAsResourceController
      include JWTSessions::RailsAuthorization
      include Pundit

      # :authorize_access_request! is part of JWTSessions and is all about ensuring valid `authenticated` requests
      before_action :authorize_access_request!

      # user must be authenticated using OAUTH2 grant from Doorkeeper
      # TODO: for Doorkeeper
      # before_action :doorkeeper_authorize!

      # got this far, let's record this request in the `SessionActivity` table
      before_action :record_session_activity

      private

      # In JSONAPI the `context` function returns a hash that is available at every lifecycle moments in the JSONAPI
      # implementation.  For Pundit in particular, it needs the current_user in order to authorize access to
      # controller actions.
      def context
        { current_user: current_user }
      end

      # Using the setting in `config/application.rb` determine whether or not to record session activity
      def record_session_activity
        return unless Rails.configuration.record_session_activity

        ruid = payload['ruid']
        session = Session.find_by!(ruid: ruid)

        if session.present?
          return RecordSessionActivityWorker.perform_async(
            Time.zone.now.iso8601,
            request.remote_ip,
            request.path,
            session.id
          )
        end

        Rails.logger.warn("Session with ruid of #{ruid} cannot be found.")
      end
    end
  end
end
