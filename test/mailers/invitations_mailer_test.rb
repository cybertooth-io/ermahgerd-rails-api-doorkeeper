# frozen_string_literal: true

require 'test_helper'

class InvitationsMailerTest < ActionMailer::TestCase
  test 'set_password' do
    mail = InvitationsMailer.set_password
    assert_equal 'Invitation - Set Your Password', mail.subject
    assert_equal ['to@example.org'], mail.to
    assert_equal ['from@example.com'], mail.from
    assert_match 'Hi', mail.body.encoded
  end
end
