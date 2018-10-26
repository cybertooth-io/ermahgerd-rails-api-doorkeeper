# frozen_string_literal: true

require 'test_helper'

class SessionActivityPolicyTest < ActiveSupport::TestCase
  test 'when create' do
    assert_not SessionActivityPolicy.new(users(:some_administrator), SessionActivity).create?
    assert_not SessionActivityPolicy.new(users(:some_guest), SessionActivity).create?
  end

  test 'when destroy' do
    assert_not SessionActivityPolicy.new(users(:some_administrator), session_activities(:sterling_archer_session_activity)).destroy?
    assert_not SessionActivityPolicy.new(users(:some_guest), session_activities(:sterling_archer_session_activity)).destroy?
  end

  test 'when index' do
    assert SessionActivityPolicy.new(users(:some_administrator), SessionActivity).index?
    assert_not SessionActivityPolicy.new(users(:some_guest), SessionActivity).index?
  end

  test 'when show' do
    assert SessionActivityPolicy.new(users(:some_administrator), session_activities(:sterling_archer_session_activity)).show?
    assert_not SessionActivityPolicy.new(users(:some_guest), session_activities(:sterling_archer_session_activity)).show?
  end

  test 'when update' do
    assert_not SessionActivityPolicy.new(users(:some_administrator), session_activities(:sterling_archer_session_activity)).update?
    assert_not SessionActivityPolicy.new(users(:some_guest), session_activities(:sterling_archer_session_activity)).update?
  end
end
