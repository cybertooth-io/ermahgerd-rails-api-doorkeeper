# frozen_string_literal: true

module Api
  module V1
    module Protected
      # Protected access to the `User` model.
      # It should go without saying that the password_digest is never passed through the wire.
      class UserResource < BaseResource
        # Attributes
        # --------------------------------------------------------------------------------------------------------------

        attributes(
          :email,
          :first_name,
          :last_name,
          :nickname,
          {}
        )

        # http://jsonapi-resources.com/v0.9/guide/resources.html#Creatable-and-Updatable-Attributes
        def self.updatable_fields(context)
          super - [:password_digest]
        end

        # http://jsonapi-resources.com/v0.9/guide/resources.html#Creatable-and-Updatable-Attributes
        def self.creatable_fields(context)
          super - [:password_digest]
        end

        # Relationships
        # --------------------------------------------------------------------------------------------------------------

        has_many :roles
        has_many :sessions
      end
    end
  end
end
