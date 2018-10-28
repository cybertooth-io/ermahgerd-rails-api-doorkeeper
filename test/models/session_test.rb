# frozen_string_literal: true

require 'test_helper'

class SessionTest < ActiveSupport::TestCase
  test 'when updating a session it is expected that invalidated by user is supplied' do
    session = sessions(:sterling_archer_session)

    session.update(invalidated: true)

    assert_equal "Invalidated By can't be blank", session.errors.full_messages.first
  end
end
