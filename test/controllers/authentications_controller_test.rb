require 'test_helper'

class AuthenticationsControllerTest < ActionDispatch::IntegrationTest
  test 'when logging in fails because the email is missing' do
    post login_url

    assert_response :not_found
    refute cookies[JWTSessions.access_cookie].present?
  end

  test 'when logging in fails because the password is missing' do
    post login_url, params: {email: 'sterling@isiservice.com'}

    assert_response :unauthorized
    refute cookies[JWTSessions.access_cookie].present?
  end

  test 'when logging in fails because the email and password do not match' do
    post login_url, params: {email: 'sterling@isiservice.com', password: 'secrets'}

    assert_response :unauthorized
    refute cookies[JWTSessions.access_cookie].present?
  end

  test 'when logging is successful' do
    assert_difference ['Session.count'] do
      post login_url, headers: {'User-Agent': USER_AGENT}, params: {email: 'sterling@isiservice.com', password: 'secret'}
    end

    assert_response :created
    assert cookies[JWTSessions.access_cookie].present?
  end

  test 'when logging out without a session' do
    delete logout_url

    assert_response :unauthorized
    assert_equal 'Token is not found', JSON.parse(response.body)['errors'].first['detail']
  end

  test 'when logging out with an access token in a cookie' do
    Timecop.freeze

    login(users(:sterling_archer))

    Timecop.travel 15.minutes.from_now

    assert cookies[JWTSessions.access_cookie].present?

    delete logout_url, headers: @headers

    assert_response :no_content
    refute cookies[JWTSessions.access_cookie].present?
  end
end
