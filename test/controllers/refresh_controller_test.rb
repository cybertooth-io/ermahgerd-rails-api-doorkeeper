require 'test_helper'

class RefreshControllerTest < ActionDispatch::IntegrationTest
  test 'when attempting to renew access token without an access cookie' do
    post renew_url

    assert_response :unauthorized, 'Access token does not exist, therefore consider this unauthorized renewal'
  end

  test 'when attempting to renew access token but without supplying the csrf token' do
    login(users(:sterling_archer))

    post renew_url

    assert_response :unauthorized, 'Access token not renewed because CSRF was missing'
  end

  test 'when renewing after signing in' do
    login(users(:sterling_archer))

    access_token_before_renew = cookies[JWTSessions.access_cookie]

    post renew_url, headers: @headers

    assert_response :created, 'Token was renewed'
    assert_not_equal access_token_before_renew, cookies[JWTSessions.access_cookie], 'Access token has changed and is renewed'
  end

  test 'when attempting to refresh but the refresh token has expired' do
    login(users(:sterling_archer))

    post renew_url, headers: @headers

    assert_response :created, 'Token was renewed'

    new_headers = Hash.new
    new_headers[JWTSessions.csrf_header] = ::JSON.parse(response.body)['csrf']

    Timecop.travel(1.week.from_now)

    post renew_url, headers: new_headers

    assert_response :unauthorized, 'The refresh token has expired'
  end
end
