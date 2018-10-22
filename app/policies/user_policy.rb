# frozen_string_literal: true

# The Pundit policy for all JSONAPI actions.
class UserPolicy < ApplicationPolicy
  def create?
    user.administrator?
  end

  def destroy?
    user.administrator?
  end

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
