# frozen_string_literal: true

# The Pundit policy for all JSONAPI actions.
class RolePolicy < ApplicationPolicy
  # This Policy's scope; defaults to everything (scope.all).
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
