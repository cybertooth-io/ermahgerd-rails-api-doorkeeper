# frozen_string_literal: true

require 'test_helper'

class RecordSessionActivityWorkerTest < ActiveSupport::TestCase
  test 'when session activity is successfully created' do
    assert_difference ['SessionActivity.count'] do
      RecordSessionActivityWorker.new.perform(
        -10.seconds.from_now.iso8601,
        '1.2.3.4',
        '/some/path/2',
        sessions(:sterling_archer_session).id
      )
    end
  end

  test 'when session activity cannot be created because session does not exist' do
    assert_no_difference ['SessionActivity.count'] do
      assert_raises ActiveRecord::RecordInvalid do
        RecordSessionActivityWorker.new.perform(
          -10.seconds.from_now.iso8601,
          '1.2.3.4',
          '/some/path/2',
          -1
        )
      end
    end
  end
end
