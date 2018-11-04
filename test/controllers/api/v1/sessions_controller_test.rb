# frozen_string_literal: true

require 'test_helper'

module Api
  module V1
    class SessionsControllerTest < ActionDispatch::IntegrationTest
      test 'when destroying another user session' do
        mallory_archer = users(:mallory_archer)
        login(mallory_archer) # logging in mallory so we can invalidate her!

        login(users(:some_administrator)) # user the administrator to invalidate Mallory's session

        session = mallory_archer.sessions.first

        patch invalidate_api_v1_session_url(session.id), headers: @headers

        assert_response :no_content

        session.reload
        assert session.invalidated?
        assert session.invalidated_by.present?
      end

      test 'when destroying a session that has already been destroyed' do
        mallory_archer = users(:mallory_archer)
        login(mallory_archer) # logging in mallory so we can invalidate her!

        login(users(:some_administrator)) # user the administrator to invalidate Mallory's session

        session = mallory_archer.sessions.first

        patch invalidate_api_v1_session_url(session.id), headers: @headers

        assert_response :no_content

        # now try to invalidate again! Using PUT this time for spice of life
        put invalidate_api_v1_session_url(session.id), headers: @headers

        assert_response :not_found
        assert_equal 'Refresh token not found', JSON.parse(response.body)['errors'].first['detail']
      end

      test 'when session is invalidated the access token is immediately unusable' do
        Timecop.freeze

        some_administrator = users(:some_administrator)
        token(some_administrator) # logging in some_administrator so we can invalidate them!
        some_administrator_headers = @headers
        some_administrator_session = some_administrator.sessions.first

        Timecop.travel 5.minutes.from_now

        login(users(:some_other_administrator)) # user the some_other_administrator to invalidate some_administrator's session

        # confirm some_administrator's session can right now access protected resources
        get api_v1_users_url, headers: some_administrator_headers

        assert_response :ok

        # now using some_other_administrator's account, invalidate some_administrator's session
        patch invalidate_api_v1_session_url(some_administrator_session.id), headers: @headers

        assert_response :no_content

        # now see if some_administrator can still use their access token
        get api_v1_users_url, headers: some_administrator_headers

        assert_response :unauthorized
      end
    end
  end
end
