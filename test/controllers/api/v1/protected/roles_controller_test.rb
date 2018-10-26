# frozen_string_literal: true

require 'test_helper'

module Api
  module V1
    module Protected
      class RolesControllerTest < ActionDispatch::IntegrationTest
        test 'when index' do
          login(users(:some_administrator))

          get api_v1_protected_roles_url

          assert_response :ok
        end

        test 'when create' do
          login(users(:some_administrator))

          post api_v1_protected_roles_url, headers: @headers, params: {
            data: {
              attributes: {
                key: 'CON',
                name: 'Contributor'
              },
              type: 'roles'
            }
          }.to_json

          assert_response :created
        end

        test 'when show' do
          login(users(:some_administrator))

          get api_v1_protected_role_url(roles(:guest))

          assert_response :ok
        end

        test 'when destroy' do
          login(users(:some_administrator))

          delete api_v1_protected_role_url(roles(:guest)), headers: @headers

          assert_response :no_content
        end

        test 'when update' do
          login(users(:some_administrator))

          role = roles(:guest)

          patch api_v1_protected_role_url(role), headers: @headers, params: {
            data: {
              attributes: {
                name: 'Guest Updated'
              },
              id: role.id,
              type: 'roles'
            }
          }.to_json

          assert_response :ok
        end

        test 'when relationships users' do
          login(users(:some_administrator))

          role = roles(:guest)

          get api_v1_protected_role_relationships_users_url(role), headers: @headers

          assert_response :ok
        end

        test 'when role users' do
          login(users(:some_administrator))

          role = roles(:guest)

          get api_v1_protected_role_users_url(role), headers: @headers

          assert_response :ok
        end
      end
    end
  end
end
