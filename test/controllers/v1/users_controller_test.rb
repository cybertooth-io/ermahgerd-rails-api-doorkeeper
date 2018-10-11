require 'test_helper'

class V1::UsersControllerTest < ActionDispatch::IntegrationTest

  test 'when attempting to access the index action without signing in' do
    get v1_users_url

    assert_response :unauthorized
  end

  test 'when logging in to get authorized access to the index action' do
    login(users(:sterling_archer))

    get v1_users_url

    assert_response :ok
    assert_equal 2, ::JSON.parse(response.body)['data'].length
  end

  test 'when show' do
    login(users(:sterling_archer))

    get  v1_user_url(users(:mallory_archer))

    assert_response :ok
    assert_equal 'mallory@isiservice.com', ::JSON.parse(response.body)['data']['attributes']['email']
  end

  test 'when destroy without specifying a CSRF token in the header' do
    login(users(:sterling_archer))

    assert_no_difference ['User.count'] do
      delete v1_user_url(users(:mallory_archer))
    end

    assert_response :unauthorized
  end

  test 'when destroy' do
    login(users(:sterling_archer))

    assert_difference ['User.count'], -1 do
      delete v1_user_url(users(:mallory_archer)), headers: @headers
    end

    assert_response :no_content
  end
end
