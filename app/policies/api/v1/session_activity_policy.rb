# frozen_string_literal: true

module Api
  module V1
    # The Pundit policy for all JSONAPI actions.
    # Unless otherwise overridden, access is to create, destroy, index, show, update is denied.
    # Notice that the SessionActivityResource is immutable; there is no create, destroy, or update through the API.
    class SessionActivityPolicy < ApplicationPolicy
      def index?
        user.administrator?
      end

      def show?
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
