# frozen_string_literal: true

module Api
  module V1
    module Public
      # TODO: this is truly for demonstration purposes; destroy this or remove it from the routes.rb
      # Unless otherwise overridden, access is to create, destroy, index, show, update is denied.
      class RolePolicy < ApplicationPolicy
        def index?
          true
        end

        def show?
          true
        end

        # This Policy's scope; defaults to everything (scope.all).
        class Scope < Scope
          def resolve
            scope.all
          end
        end
      end
    end
  end
end
