# frozen_string_literal: true

require 'test_helper'

module Api
  module V1
    module Protected
      class RolePolicyTest < ActiveSupport::TestCase
        test 'when create' do
          assert RolePolicy.new(users(:some_administrator), Role).create?
          assert_not RolePolicy.new(users(:some_guest), Role).create?
        end

        test 'when destroy' do
          assert RolePolicy.new(users(:some_administrator), roles(:administrator)).destroy?
          assert_not RolePolicy.new(users(:some_guest), roles(:administrator)).destroy?
        end

        test 'when index' do
          assert RolePolicy.new(users(:some_administrator), Role).index?
          assert_not RolePolicy.new(users(:some_guest), Role).index?
        end

        test 'when show' do
          assert RolePolicy.new(users(:some_administrator), roles(:administrator)).show?
          assert_not RolePolicy.new(users(:some_guest), roles(:administrator)).show?
        end

        test 'when update' do
          assert RolePolicy.new(users(:some_administrator), roles(:administrator)).update?
          assert_not RolePolicy.new(users(:some_guest), roles(:administrator)).update?
        end
      end
    end
  end
end
