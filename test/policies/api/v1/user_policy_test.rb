# frozen_string_literal: true

require 'test_helper'

module Api
  module V1
    class UserPolicyTest < ActiveSupport::TestCase
      test 'when create' do
        assert UserPolicy.new(users(:some_administrator), User).create?
        assert_not UserPolicy.new(users(:some_guest), User).create?
      end

      test 'when destroy' do
        assert UserPolicy.new(users(:some_administrator), users(:sterling_archer)).destroy?
        assert_not UserPolicy.new(users(:some_guest), users(:sterling_archer)).destroy?
      end

      test 'when index' do
        assert UserPolicy.new(users(:some_administrator), User).index?
        assert_not UserPolicy.new(users(:some_guest), User).index?
      end

      test 'when show' do
        assert UserPolicy.new(users(:some_administrator), users(:sterling_archer)).show?
        assert_not UserPolicy.new(users(:some_guest), users(:sterling_archer)).show?
      end

      test 'when showing my user record' do
        assert UserPolicy.new(users(:some_guest), users(:some_guest)).show?
      end

      test 'when update' do
        assert UserPolicy.new(users(:some_administrator), users(:sterling_archer)).update?
        assert_not UserPolicy.new(users(:some_guest), users(:sterling_archer)).update?
      end

      test 'when updating my user record' do
        assert UserPolicy.new(users(:some_guest), users(:some_guest)).update?
      end
    end
  end
end
