ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'sidekiq/testing'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Set up fake Sidekiq queuing (see https://github.com/mperham/sidekiq/wiki/Testing#testing-worker-queueing-fake)
  Sidekiq::Testing.fake!

  # Return time back to normal after each test case
  teardown do
    Timecop.return
  end

  # Helper to log a given user in
  # @return headers with the `X-CSRF-Token` assigned; you must pass this to your HTTP actions (e.g. `get v1_users_url, headers: @headers`)
  def login(user, options = {})
    password = options[:password] || 'secret' # default 'secret'

    Rails.logger.info "------------------------------------------------------------------------------------------"
    Rails.logger.info "Logging in as #{user.email}"
    Rails.logger.info "------------------------------------------------------------------------------------------"

    post login_url, params: { email: user.email, password: password }

    @csrf_token = ::JSON.parse(response.body)['csrf']
    @headers = Hash.new
    @headers[JWTSessions.csrf_header] = @csrf_token
  end
end
