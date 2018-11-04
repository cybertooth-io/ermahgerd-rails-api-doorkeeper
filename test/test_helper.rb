# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'sidekiq/testing'

module ActiveSupport
  class TestCase
    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    USER_AGENT = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/601.3.9 (KHTML, like Gecko) Version/9.0.2 Safari/601.3.9'

    # Set up fake Sidekiq queuing (see https://github.com/mperham/sidekiq/wiki/Testing#testing-worker-queueing-fake)
    Sidekiq::Testing.fake!

    # Return time back to normal after each test case
    teardown do
      Timecop.return
    end

    # Helper to log a given user in with cookie based authentication
    # @return headers with the `X-CSRF-Token` assigned; you must pass this to your HTTP actions (e.g. `get v1_users_url, headers: @headers`)
    def login(user, options = {})
      password = options[:password] || 'secret' # default 'secret'

      Rails.logger.info '------------------------------------------------------------------------------------------'
      Rails.logger.info "Cookie Authentication as #{user.email}"
      Rails.logger.info '------------------------------------------------------------------------------------------'

      post cookie_login_url, headers: { 'User-Agent': USER_AGENT }, params: { email: user.email, password: password }

      @csrf_token = ::JSON.parse(response.body)['csrf']
      @headers = { 'Content-Type': JSONAPI::MEDIA_TYPE }
      @headers[JWTSessions.csrf_header] = @csrf_token
    end

    # Helper to log a given user in with cookie based authentication
    # @return headers with the `X-CSRF-Token` assigned; you must pass this to your HTTP actions (e.g. `get v1_users_url, headers: @headers`)
    def token(user, options = {})
      password = options[:password] || 'secret' # default 'secret'

      Rails.logger.info '------------------------------------------------------------------------------------------'
      Rails.logger.info "Token Authentication as #{user.email}"
      Rails.logger.info '------------------------------------------------------------------------------------------'

      post token_login_url, headers: { 'User-Agent': USER_AGENT }, params: { email: user.email, password: password }

      @access_token = ::JSON.parse(response.body)['access']
      @headers = { 'Content-Type': JSONAPI::MEDIA_TYPE }
      @headers[JWTSessions.access_header] = @access_token
    end
  end
end
