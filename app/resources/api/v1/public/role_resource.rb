# frozen_string_literal: true

module Api
  module V1
    module Public
      # Public read-only access to the `Role` model.
      # TODO: this is truly for demonstration purposes; destroy this or remove it from the routes.rb
      class RoleResource < BaseResource
        immutable
      end
    end
  end
end
