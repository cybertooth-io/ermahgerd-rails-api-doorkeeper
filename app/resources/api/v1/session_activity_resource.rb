# frozen_string_literal: true

module Api
  module V1
    # Protected access to the `SessionActivity` model.
    # Removing the `updated_at` field from the fetchable fields because we're manually passing it in during creation.
    class SessionActivityResource < BaseResource
      immutable # no CUD through controller

      # Attributes
      # ----------------------------------------------------------------------------------------------------------------

      # Notice that we're not serializing the RUID column; keep that hidden to the public
      attributes(
        :ip_address,
        :path,
        {}
      )

      # http://jsonapi-resources.com/v0.9/guide/resources.html#Creatable-and-Updatable-Attributes
      def self.creatable_fields(_context)
        [] # immutable
      end

      def self.fetchable_fields(_context)
        super - [:updated_at]
      end

      # http://jsonapi-resources.com/v0.9/guide/resources.html#Creatable-and-Updatable-Attributes
      def self.updatable_fields(_context)
        [] # immutable
      end

      # Relationships
      # ----------------------------------------------------------------------------------------------------------------

      has_one :session
    end
  end
end
