# frozen_string_literal: true

module Api
  module V1
    module Public
      # TODO: this is truly for demonstration purposes; destroy this or remove it from the routes.rb
      # Simple JSONAPI controller that offers up all the read-only actions.
      class RolesController < ApplicationController
        include JSONAPI::ActsAsResourceController
      end
    end
  end
end
