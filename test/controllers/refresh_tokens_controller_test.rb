# frozen_string_literal: true

require 'test_helper'

class RefreshTokensControllerTest < ActionDispatch::IntegrationTest
  test 'when attempting to renew access token without an access cookie' do
    post token_refresh_url

    assert_response :unauthorized
  end

  test 'when renewing an access token a few seconds before access-expiry' do
    Timecop.freeze

    token(users(:sterling_archer))

    Timecop.travel((JWTSessions.access_exp_time - 3).seconds.from_now)

    post token_refresh_url, headers: @headers

    assert_response :unauthorized
    assert_equal 'Malicious activity detected', JSON.parse(response.body)['errors'].first['detail']
  end

  test 'when renewing an access token a few seconds after access-expiry' do
    Timecop.freeze

    token(users(:sterling_archer))

    Timecop.travel((JWTSessions.access_exp_time + 3).seconds.from_now)

    post token_refresh_url, headers: @headers

    assert_response :created
    assert JSON.parse(response.body)['access']
    assert_not_equal @access_token, JSON.parse(response.body)['access']
  end

  test 'when refresh of access token succeeds a few seconds BEFORE REFRESH expiry' do
    Timecop.freeze

    token(users(:sterling_archer))

    Timecop.travel((JWTSessions.refresh_exp_time - 3).seconds.from_now)

    post token_refresh_url, headers: @headers

    assert_response :created
    assert JSON.parse(response.body)['access']
    assert_not_equal @access_token, JSON.parse(response.body)['access']
  end

  test 'when refresh of access token fails a few seconds AFTER REFRESH expiry' do
    Timecop.freeze

    login(users(:sterling_archer))

    Timecop.travel((JWTSessions.refresh_exp_time + 3).seconds.from_now)

    post token_refresh_url, headers: @headers

    assert_response :unauthorized
    assert_equal 'Session has expired', JSON.parse(response.body)['errors'].first['detail']
  end

  test 'when renewing an access token and performing a DELETE with the new token' do
    Timecop.freeze

    token(users(:some_administrator))

    Timecop.travel((JWTSessions.access_exp_time + 3).seconds.from_now)

    # delete should fail because access token is expired
    assert_no_difference ['User.count'] do
      delete api_v1_protected_user_url(users(:mallory_archer).id), headers: @headers
    end
    assert_response :unauthorized

    # renew the access token
    post token_refresh_url, headers: @headers

    assert_response :created
    assert_not_equal @access_token, JSON.parse(response.body)['access']

    # set up the request header hash with the renewed access token
    new_headers = {}
    new_headers[JWTSessions.access_header] = JSON.parse(response.body)['access']

    # now attempt to delete with the renewed access token
    assert_difference ['User.count'], -1 do
      delete api_v1_protected_user_url(users(:mallory_archer).id), headers: new_headers
    end
    assert_response :no_content, 'Delete was successful'
  end
end
