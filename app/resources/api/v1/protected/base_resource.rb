# frozen_string_literal: true

module Api
  module V1
    module Protected
      # All resources that wish to be restricted via pundit policies should inherit from this abstract
      # JSONAPI::Resource
      # This resource makes a point of not permitting the create/update of the `created_at` or `updated_at` fields.
      class BaseResource < JSONAPI::Resource
        include JSONAPI::Authorization::PunditScopedResource
        abstract

        # Attributes
        # --------------------------------------------------------------------------------------------------------------

        attributes(
          :created_at,
          :updated_at,
          {}
        )

        # http://jsonapi-resources.com/v0.9/guide/resources.html#Creatable-and-Updatable-Attributes
        def self.updatable_fields(context)
          super - %i[created_at updated_at]
        end

        # http://jsonapi-resources.com/v0.9/guide/resources.html#Creatable-and-Updatable-Attributes
        def self.creatable_fields(context)
          super - %i[created_at updated_at]
        end
      end
    end
  end
end
