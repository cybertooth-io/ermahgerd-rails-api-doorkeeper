# frozen_string_literal: true

module Api
  module V1
    # Protected access to the `User` model.
    # It should go without saying that the password_digest is never passed through the wire.
    # :password & :password_confirmation will be accepted on create and update but will never be sent back through
    # the wire.
    class UserResource < BaseResource
      # Callbacks
      # ----------------------------------------------------------------------------------------------------------------

      # Attributes
      # ----------------------------------------------------------------------------------------------------------------

      attributes(
        :email,
        :first_name,
        :last_name,
        :nickname,
        {}
      )

      # http://jsonapi-resources.com/v0.9/guide/resources.html#Creatable-and-Updatable-Attributes
      def self.updatable_fields(context)
        super + %i[password password_confirmed] - [:password_digest]
      end

      # http://jsonapi-resources.com/v0.9/guide/resources.html#Creatable-and-Updatable-Attributes
      def self.creatable_fields(context)
        super + %i[password password_confirmed] - [:password_digest]
      end

      # Relationships
      # ----------------------------------------------------------------------------------------------------------------

      has_many :roles
      has_many :sessions
    end
  end
end
