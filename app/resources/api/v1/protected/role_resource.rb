# frozen_string_literal: true

module Api
  module V1
    module Protected
      # Protected access to the `Role` model.
      # Once a Role's `key` has been defined it cannot be updated; removed it from the `updatable_fields`.
      class RoleResource < BaseResource
        # Attributes
        # --------------------------------------------------------------------------------------------------------------

        attributes(
          :key,
          :name,
          :notes,
          {}
        )

        # http://jsonapi-resources.com/v0.9/guide/resources.html#Creatable-and-Updatable-Attributes
        def self.updatable_fields(_context)
          super - [:key]
        end

        # Relationships
        # --------------------------------------------------------------------------------------------------------------

        has_many :users
      end
    end
  end
end
