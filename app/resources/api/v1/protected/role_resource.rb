# frozen_string_literal: true

module Api
  module V1
    module Protected
      # Protected access to the `Role` model.
      class RoleResource < BaseResource
        # Attributes
        # --------------------------------------------------------------------------------------------------------------

        attributes(
          :key,
          :name,
          :notes,
          {}
        )

        # Relationships
        # --------------------------------------------------------------------------------------------------------------

        has_many :users
      end
    end
  end
end
