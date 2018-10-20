# frozen_string_literal: true

require 'test_helper'

class RefreshCookiesControllerTest < ActionDispatch::IntegrationTest
  test 'when attempting to renew access token without an access cookie' do
    post cookie_refresh_url

    assert_response :unauthorized
  end

  test 'when attempting to renew access token but without supplying the csrf token' do
    login(users(:sterling_archer))

    post cookie_refresh_url

    assert_response :unauthorized
  end

  test 'when renewing an access token one second before access-expiry' do
    Timecop.freeze

    login(users(:sterling_archer))

    Timecop.travel((JWTSessions.access_exp_time - 1).seconds.from_now)

    post cookie_refresh_url, headers: @headers

    # TODO: sometimes this assertion fails; if you re-run the test it might work.  Timecop must be fucked?
    assert_response :unauthorized
    assert_equal 'Malicious activity detected', JSON.parse(response.body)['errors'].first['detail']
  end

  test 'when renewing an access token one second after access-expiry' do
    Timecop.freeze

    login(users(:sterling_archer))

    Timecop.travel((JWTSessions.access_exp_time + 1).seconds.from_now)

    post cookie_refresh_url, headers: @headers

    assert_response :created
  end

  test 'when renewing an access token one second after access-expiry and then attempting to use old CSRF' do
    Timecop.freeze

    login(users(:sterling_archer))

    Timecop.travel((JWTSessions.access_exp_time + 1).seconds.from_now)

    post cookie_refresh_url, headers: @headers

    assert_response :created

    new_headers = {}
    new_headers[JWTSessions.csrf_header] = JSON.parse(response.body)['csrf']

    Timecop.travel(5.minutes.from_now)

    # attempt to delete user with old CSRF token (@headers has not been updated since call to `login(...)`)
    assert_no_difference ['User.count'] do
      delete api_v1_protected_user_url(users(:mallory_archer).id), headers: @headers
    end

    assert_response :unauthorized, 'CSRF token mismatch should have been detected'

    # now attempt to delete with the newly issued CSRF
    assert_difference ['User.count'], -1 do
      delete api_v1_protected_user_url(users(:mallory_archer).id), headers: new_headers
    end

    assert_response :no_content, 'Re-issued CSRF token was used, delete should complete successfully'
  end

  test 'when refresh of access token succeeds one second BEFORE REFRESH expiry' do
    Timecop.freeze

    login(users(:sterling_archer))

    Timecop.travel((JWTSessions.refresh_exp_time - 1).seconds.from_now)

    post cookie_refresh_url, headers: @headers

    assert_response :created
  end

  test 'when refresh of access token fails one second AFTER REFRESH expiry' do
    Timecop.freeze

    login(users(:sterling_archer))

    Timecop.travel((JWTSessions.refresh_exp_time + 1).seconds.from_now)

    post cookie_refresh_url, headers: @headers

    assert_response :unauthorized
    assert_equal 'Session has expired', JSON.parse(response.body)['errors'].first['detail']
  end
end
