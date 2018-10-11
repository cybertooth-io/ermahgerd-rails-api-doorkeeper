require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test 'when logging in fails because the email is missing' do
    post login_url

    assert_response :not_found
    assert cookies[JWTSessions.access_cookie].nil?
    assert cookies[JWTSessions.refresh_cookie].nil?
  end

  test 'when logging in fails because the password is missing' do
    post login_url, params: { email: 'sterling@isiservice.com' }

    assert_response :unauthorized
    assert cookies[JWTSessions.access_cookie].nil?
    assert cookies[JWTSessions.refresh_cookie].nil?
  end

  test 'when logging in fails because the email and password do not match' do
    post login_url, params: { email: 'sterling@isiservice.com', password: 'secrets' }

    assert_response :unauthorized
    assert cookies[JWTSessions.access_cookie].nil?
    assert cookies[JWTSessions.refresh_cookie].nil?
  end

  test 'when logging is successful' do
    post login_url, params: { email: 'sterling@isiservice.com', password: 'secret' }

    assert_response :created
    assert cookies[JWTSessions.access_cookie].present?
    assert cookies[JWTSessions.refresh_cookie].present?
  end
end
