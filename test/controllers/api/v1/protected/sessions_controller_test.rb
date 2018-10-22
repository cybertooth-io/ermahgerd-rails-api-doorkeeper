# frozen_string_literal: true

require 'test_helper'

module Api
  module V1
    module Protected
      class SessionsControllerTest < ActionDispatch::IntegrationTest
        test 'when destroying another user session' do
          mallory_archer = users(:mallory_archer)
          login(mallory_archer) # logging in mallory so we can invalidate her!

          login(users(:sterling_archer)) # now for this test session STOMP mallory's sign in (her session still exists!)

          session = mallory_archer.sessions.first

          patch invalidate_api_v1_protected_session_url(session.id), headers: @headers

          assert_response :no_content

          session.reload
          assert session.invalidated?
          assert session.invalidated_by.present?
        end

        test 'when destroying a session that has already been destroyed' do
          mallory_archer = users(:mallory_archer)
          login(mallory_archer) # logging in mallory so we can invalidate her!
          login(users(:sterling_archer))

          session = mallory_archer.sessions.first

          patch invalidate_api_v1_protected_session_url(session.id), headers: @headers

          assert_response :no_content

          # now try to invalidate again! Using PUT this time for spice of life
          put invalidate_api_v1_protected_session_url(session.id), headers: @headers

          assert_response :unauthorized
        end

        test 'when session is invalidated the access token is immediately unusable' do
          Timecop.freeze

          mallory_archer = users(:mallory_archer)
          token(mallory_archer) # logging in mallory so we can invalidate her!
          mallory_archer_headers = @headers
          mallory_archer_session = mallory_archer.sessions.first

          Timecop.travel 5.minutes.from_now

          login(users(:sterling_archer))

          # confirm Mallory Archer's session can right now access protected resources
          get api_v1_protected_users_url, headers: mallory_archer_headers

          assert_response :ok

          # now using Sterling's account, invalidate Mallory's session
          patch invalidate_api_v1_protected_session_url(mallory_archer_session.id), headers: @headers

          assert_response :no_content

          # now see if Mallory can still use her access token
          get api_v1_protected_users_url, headers: mallory_archer_headers

          assert_response :unauthorized
        end
      end
    end
  end
end
