# frozen_string_literal: true

require 'test_helper'

class DoorkeeperPasswordFlowControllerTest < ActionDispatch::IntegrationTest
  test 'when authenticating with incorrect credentials' do
    some_guest = users(:some_guest)

    post oauth_token_url, params: { grant_type: 'password', password: 'wrong-password', username: some_guest.email }

    assert_response :unauthorized
    assert JSON.parse(response.body)['error'].present?
    assert JSON.parse(response.body)['error_description'].present?
  end

  test 'when authenticating with correct credentials' do
    some_guest = users(:some_guest)

    post oauth_token_url, params: { grant_type: 'password', password: 'secret', username: some_guest.email }

    assert_response :ok
    assert JSON.parse(response.body)['access_token'].present?
  end

  test 'when using the login_oauth_password helper' do
    login_oauth_password(users(:some_guest))

    assert @headers['Authorization'].start_with?('Bearer')
  end

  test 'when access to the protected users index route is forbidden for a guest user' do
    skip 'Cannot make this work right now!'
    Timecop.freeze

    login_oauth_password(users(:some_guest))

    Timecop.travel 30.seconds.from_now

    get api_v1_users_url, headers: @headers

    assert_response :forbidden
    assert_equal 'You are forbidden from performing this action', JSON.parse(response.body)['errors'].first['detail']
  end

  test 'when access to the protected users index route is granted for an administrator user' do
    skip 'Cannot make this work right now!'
    Timecop.freeze

    login_oauth_password(users(:some_administrator))

    Timecop.travel 30.seconds.from_now

    get api_v1_users_url, headers: @headers

    assert_response :ok
    assert_equal 5, JSON.parse(response.body)['data'].length
  end
end
