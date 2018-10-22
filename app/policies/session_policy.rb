# frozen_string_literal: true

# The Pundit policy for all JSONAPI actions.
class SessionPolicy < ApplicationPolicy
  def invalidate?
    scope.where(id: record.id).exists?
  end

  # This Policy's scope; defaults to everything (scope.all).
  class Scope < Scope
    def resolve
      return scope.all if user.administrator?

      scope.merge(Session.by_user(user.id))
    end
  end
end
