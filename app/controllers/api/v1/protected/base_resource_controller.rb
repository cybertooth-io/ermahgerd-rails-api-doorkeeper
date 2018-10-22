# frozen_string_literal: true

module Api
  module V1
    module Protected
      # This is a JSONAPI-Resources ready controller that tests authentication using JWTSessions and tests
      # authorization using Pundit policies.
      class BaseResourceController < ApplicationController
        include JSONAPI::ActsAsResourceController
        include Pundit
        # :authorize_access_request! is part of JWTSessions and is all about ensuring valid `authenticated` requests
        before_action :authorize_access_request!

        private

        # In JSONAPI the `context` function returns a hash that is available at very lifecycle moments in the JSONAPI
        # implementation.  For Pundit in particular, it needs the current_user in order to authorize access to
        # controller actions.
        def context
          { current_user: current_user }
        end
      end
    end
  end
end
