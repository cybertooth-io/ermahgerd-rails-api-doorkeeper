# frozen_string_literal: true

require 'test_helper'

module Api
  module V1
    module Protected
      class UsersControllerTest < ActionDispatch::IntegrationTest
        test 'when attempting to access the index action without signing in' do
          get api_v1_protected_users_url

          assert_response :unauthorized
        end

        test 'when logging in to get authorized access to the index action' do
          login(users(:sterling_archer))

          get api_v1_protected_users_url

          assert_response :ok
          assert_equal 4, ::JSON.parse(response.body)['data'].length
        end

        test 'when accessing resource a few seconds before access token expires' do
          Timecop.freeze

          login(users(:sterling_archer))

          Timecop.travel((JWTSessions.access_exp_time - 3).seconds.from_now)

          get api_v1_protected_users_url

          assert_response :ok
          assert_equal 4, ::JSON.parse(response.body)['data'].length
        end

        test 'when accessing resource a few seconds after access token expires' do
          Timecop.freeze

          login(users(:sterling_archer))

          Timecop.travel((JWTSessions.access_exp_time + 3).seconds.from_now)

          get api_v1_protected_users_url

          assert_response :unauthorized
          assert_equal 'Signature has expired', ::JSON.parse(response.body)['errors'].first['detail']
        end

        test 'when show' do
          login(users(:sterling_archer))

          get api_v1_protected_user_url(users(:mallory_archer))

          assert_response :ok
          assert_equal 'mallory@isiservice.com', ::JSON.parse(response.body)['data']['attributes']['email']
        end

        test 'when destroy without specifying a CSRF token in the header' do
          login(users(:sterling_archer))

          assert_no_difference ['User.count'] do
            delete api_v1_protected_user_url(users(:mallory_archer))
          end

          assert_response :unauthorized
        end

        test 'when destroy by a permited user' do
          login(users(:some_administrator))

          assert_difference ['User.count'], -1 do
            delete api_v1_protected_user_url(users(:mallory_archer)), headers: @headers
          end

          assert_response :no_content
        end
      end
    end
  end
end
