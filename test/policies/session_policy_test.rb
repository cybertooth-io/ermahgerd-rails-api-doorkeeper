# frozen_string_literal: true

require 'test_helper'

class SessionPolicyTest < ActiveSupport::TestCase
  test 'when create' do
    assert_not SessionPolicy.new(users(:some_administrator), Session).create?
    assert_not SessionPolicy.new(users(:some_guest), Session).create?
  end

  test 'when destroy' do
    assert_not SessionPolicy.new(users(:some_administrator), sessions(:sterling_archer_session)).destroy?
    assert_not SessionPolicy.new(users(:some_guest), sessions(:sterling_archer_session)).destroy?
  end

  test 'when index' do
    assert SessionPolicy.new(users(:some_administrator), Session).index?
    assert SessionPolicy.new(users(:some_guest), Session).index?
  end

  test 'when invalidating' do
    assert SessionPolicy.new(users(:some_administrator), sessions(:sterling_archer_session)).invalidate?
    assert_not SessionPolicy.new(users(:some_guest), sessions(:sterling_archer_session)).invalidate?
  end

  test 'when invalidating my session record' do
    assert SessionPolicy.new(users(:sterling_archer), sessions(:sterling_archer_session)).invalidate?
  end

  test 'when show' do
    assert SessionPolicy.new(users(:some_administrator), sessions(:sterling_archer_session)).show?
    assert_not SessionPolicy.new(users(:some_guest), sessions(:sterling_archer_session)).show?
  end

  test 'when showing my user record' do
    assert SessionPolicy.new(users(:sterling_archer), sessions(:sterling_archer_session)).show?
  end

  test 'when update' do
    assert_not SessionPolicy.new(users(:some_administrator), sessions(:sterling_archer_session)).update?
    assert_not SessionPolicy.new(users(:some_guest), sessions(:sterling_archer_session)).update?
  end

  test 'when updating my user record' do
    assert_not SessionPolicy.new(users(:sterling_archer), sessions(:sterling_archer_session)).update?
  end
end
