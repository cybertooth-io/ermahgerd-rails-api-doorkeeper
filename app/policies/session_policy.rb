# frozen_string_literal: true

# The Pundit policy for all JSONAPI actions.
# Unless otherwise overridden, access is to create, destroy, index, show, update is denied.
class SessionPolicy < ApplicationPolicy
  # By default index is permitted by all; the scope will constrain what is available.
  def index?
    true
  end

  # Any administrator can invalidate any session.
  # Others will only be able to invalidate sessions that are bound to their user account.
  def invalidate?
    user.administrator? || record.user.id == user.id
  end

  # Any administrator can show any session.
  # Others will only be able to show sessions that are bound to their user account.
  def show?
    invalidate?
  end

  # Administrator's have access to ALL session records.
  # Everyone else can only see their own session records.
  class Scope < Scope
    def resolve
      return scope.all if user.administrator?

      scope.merge(Session.by_user(user.id))
    end
  end
end
