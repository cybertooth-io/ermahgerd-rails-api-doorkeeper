# frozen_string_literal: true

require 'test_helper'

class CookieAuthenticationsControllerTest < ActionDispatch::IntegrationTest
  test 'when logging in fails because the email is missing' do
    assert_no_difference ['Session.count'] do
      post cookie_login_url
    end

    assert_response :not_found
    refute cookies[JWTSessions.access_cookie].present?
  end

  test 'when logging in fails because the password is missing' do
    assert_no_difference ['Session.count'] do
      post cookie_login_url, params: { email: 'sterling@isiservice.com' }
    end

    assert_response :unauthorized
    refute cookies[JWTSessions.access_cookie].present?
  end

  test 'when logging in fails because the email and password do not match' do
    assert_no_difference ['Session.count'] do
      post cookie_login_url, params: { email: 'sterling@isiservice.com', password: 'secrets' }
    end

    assert_response :unauthorized
    refute cookies[JWTSessions.access_cookie].present?
  end

  test 'when logging in is successful' do
    assert_difference ['Session.count'] do
      post cookie_login_url, headers: { 'User-Agent': USER_AGENT }, params: { email: 'sterling@isiservice.com', password: 'secret' }
    end

    assert_response :created
    assert cookies[JWTSessions.access_cookie].present?
  end

  test 'when logging out without a session' do
    delete cookie_logout_url

    assert_response :unauthorized
    assert_equal 'Token is not found', JSON.parse(response.body)['errors'].first['detail']
  end

  test 'when logging out successfully the cookie is destroyed' do
    Timecop.freeze

    login(users(:sterling_archer))

    Timecop.travel 15.minutes.from_now

    assert cookies[JWTSessions.access_cookie].present?

    delete cookie_logout_url, headers: @headers

    assert_response :no_content
    refute cookies[JWTSessions.access_cookie].present?
  end

  test 'when logging out successfully the Session invalidated fields are updated' do
    Timecop.freeze

    sterling = users(:sterling_archer)

    login(sterling)

    Timecop.travel 15.minutes.from_now

    refute sterling.sessions.first.invalidated?

    delete cookie_logout_url, headers: @headers

    assert_response :no_content
    assert sterling.sessions.first.invalidated?
    assert sterling.sessions.first.invalidated_by.present?
  end
end
