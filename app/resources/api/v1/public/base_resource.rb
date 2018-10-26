# frozen_string_literal: true

module Api
  module V1
    module Public
      # A Pundit-Scoped resource used in conjunction with its namespaced policy.
      # This resource is abstract and as such the api will prevent and destructive actions.
      class BaseResource < JSONAPI::Resource
        abstract

        # Attributes
        # --------------------------------------------------------------------------------------------------------------

        attributes(
          :created_at,
          :updated_at,
          {}
        )
      end
    end
  end
end
