# frozen_string_literal: true

module Api
  module V1
    # The Pundit policy for all JSONAPI actions.
    # Unless otherwise overridden, access is to create, destroy, index, show, update is denied.
    class UserPolicy < ApplicationPolicy
      def create?
        user.administrator?
      end

      def destroy?
        create?
      end

      def index?
        create?
      end

      # can show/see your own user record; or if you're administrator can show/see everyone's user record
      def show?
        user.id == record.id || user.administrator?
      end

      # can update your own user record; or if you're administrator can update everyone's user record
      def update?
        show?
      end

      # Administrator's have access to ALL user records.
      # Everyone else can only see their own user record.
      class Scope < Scope
        def resolve
          return scope.all if user.administrator?

          scope.by_id user.id
        end
      end
    end
  end
end
