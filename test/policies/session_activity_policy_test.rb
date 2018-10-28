# frozen_string_literal: true

require 'test_helper'

class SessionActivityPolicyTest < ActiveSupport::TestCase
  test 'when create' do
    refute SessionActivityPolicy.new(users(:some_administrator), SessionActivity).create?
    refute SessionActivityPolicy.new(users(:some_guest), SessionActivity).create?
  end

  test 'when destroy' do
    refute SessionActivityPolicy.new(users(:some_administrator), session_activities(:sterling_archer_session_activity)).destroy?
    refute SessionActivityPolicy.new(users(:some_guest), session_activities(:sterling_archer_session_activity)).destroy?
  end

  test 'when index' do
    assert SessionActivityPolicy.new(users(:some_administrator), SessionActivity).index?
    refute SessionActivityPolicy.new(users(:some_guest), SessionActivity).index?
  end

  test 'when show' do
    assert SessionActivityPolicy.new(users(:some_administrator), session_activities(:sterling_archer_session_activity)).show?
    refute SessionActivityPolicy.new(users(:some_guest), session_activities(:sterling_archer_session_activity)).show?
  end

  test 'when update' do
    refute SessionActivityPolicy.new(users(:some_administrator), session_activities(:sterling_archer_session_activity)).update?
    refute SessionActivityPolicy.new(users(:some_guest), session_activities(:sterling_archer_session_activity)).update?
  end
end
