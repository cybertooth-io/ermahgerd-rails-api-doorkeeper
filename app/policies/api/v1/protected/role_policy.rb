# frozen_string_literal: true

module Api
  module V1
    module Protected
      # Unless otherwise overridden, access is to create, destroy, index, show, update is denied.
      class RolePolicy < ApplicationPolicy
        def create?
          user.administrator?
        end

        def destroy?
          user.administrator?
        end

        def index?
          user.administrator?
        end

        def show?
          user.administrator?
        end

        def update?
          user.administrator?
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
