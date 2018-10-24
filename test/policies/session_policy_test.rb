# frozen_string_literal: true

require 'test_helper'

class SessionPolicyTest < ActiveSupport::TestCase
  test 'when create' do
    refute SessionPolicy.new(users(:some_administrator), Session).create?
    refute SessionPolicy.new(users(:some_guest), Session).create?
  end

  test 'when destroy' do
    refute SessionPolicy.new(users(:some_administrator), sessions(:sterling_archer_session)).destroy?
    refute SessionPolicy.new(users(:some_guest), sessions(:sterling_archer_session)).destroy?
  end

  test 'when index' do
    assert SessionPolicy.new(users(:some_administrator), Session).index?
    assert SessionPolicy.new(users(:some_guest), Session).index?
  end

  test 'when invalidating' do
    assert SessionPolicy.new(users(:some_administrator), sessions(:sterling_archer_session)).invalidate?
    refute SessionPolicy.new(users(:some_guest), sessions(:sterling_archer_session)).invalidate?
  end

  test 'when invalidating my session record' do
    assert SessionPolicy.new(users(:sterling_archer), sessions(:sterling_archer_session)).invalidate?
  end

  test 'when show' do
    assert SessionPolicy.new(users(:some_administrator), sessions(:sterling_archer_session)).show?
    refute SessionPolicy.new(users(:some_guest), sessions(:sterling_archer_session)).show?
  end

  test 'when showing my user record' do
    assert SessionPolicy.new(users(:sterling_archer), sessions(:sterling_archer_session)).show?
  end

  test 'when update' do
    refute SessionPolicy.new(users(:some_administrator), sessions(:sterling_archer_session)).update?
    refute SessionPolicy.new(users(:some_guest), sessions(:sterling_archer_session)).update?
  end

  test 'when updating my user record' do
    refute SessionPolicy.new(users(:sterling_archer), sessions(:sterling_archer_session)).update?
  end
end
