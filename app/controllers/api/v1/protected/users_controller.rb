# frozen_string_literal: true

module Api
  module V1
    module Protected
      # Simple JSONAPI controller that offers up all the basic actions.
      class UsersController < ApplicationController
        include JSONAPI::ActsAsResourceController

        before_action :authorize_access_request!
      end
    end
  end
end
