require 'test_helper'

class Api::V1::Protected::SessionsControllerTest < ActionDispatch::IntegrationTest
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
end
