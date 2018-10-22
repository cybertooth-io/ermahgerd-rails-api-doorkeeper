# frozen_string_literal: true

# The default Pundit policy; in fact Pundit generated this for us.
#
# I've commented the update? method because it's special as `JSONAPI-AUTHORIZATION` gem uses this method to
# test whether releated resources can be created, updated, or destroyed.
#
# I've also added a keen helper method named `scope` that can be used by inheriting classes to grab a
# reference to the records that are subject to authorization.  You can then do things like test whether
# the record be authorized actually is inside of the scoped records; this is typically a sign that someone
# is authorized to bugger with that record.
class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def create?
    false
  end

  def destroy?
    false
  end

  def index?
    false
  end

  def show?
    false
  end

  # This method will also be used to determine whether related resources can be created, updated, or deleted.
  # Finer control can be taken for related resources: @see https://github.com/venuu/jsonapi-authorization#policies
  def update?
    false
  end

  # helper method to get access to the scoped records during authorization check
  def scope
    Pundit.policy_scope!(user, record.class)
  end

  # This Policy's scope; defaults to everything (scope.all).
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end
end
