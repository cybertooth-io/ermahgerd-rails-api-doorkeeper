# frozen_string_literal: true

require 'test_helper'

class RolePolicyTest < ActiveSupport::TestCase
  test 'when create' do
    assert RolePolicy.new(users(:some_administrator), Role).create?
    refute RolePolicy.new(users(:some_guest), Role).create?
  end

  test 'when destroy' do
    assert RolePolicy.new(users(:some_administrator), roles(:administrator)).destroy?
    refute RolePolicy.new(users(:some_guest), roles(:administrator)).destroy?
  end

  test 'when index' do
    assert RolePolicy.new(users(:some_administrator), Role).index?
    refute RolePolicy.new(users(:some_guest), Role).index?
  end

  test 'when show' do
    assert RolePolicy.new(users(:some_administrator), roles(:administrator)).show?
    refute RolePolicy.new(users(:some_guest), roles(:administrator)).show?
  end

  test 'when update' do
    assert RolePolicy.new(users(:some_administrator), roles(:administrator)).update?
    refute RolePolicy.new(users(:some_guest), roles(:administrator)).update?
  end
end
