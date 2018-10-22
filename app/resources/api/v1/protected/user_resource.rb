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
          :created_at,
          :email,
          :first_name,
          :last_name,
          :nickname,
          :updated_at,
          {}
        )

        # Relationships
        # --------------------------------------------------------------------------------------------------------------

        has_many :sessions
      end
    end
  end
end
