# frozen_string_literal: true

module Api
  module V1
    module Protected
      # All resources that wish to be restricted via pundit policies should inherit from this abstract
      # JSONAPI::Resource
      class BaseResource < JSONAPI::Resource
        include JSONAPI::Authorization::PunditScopedResource
        abstract
      end
    end
  end
end
