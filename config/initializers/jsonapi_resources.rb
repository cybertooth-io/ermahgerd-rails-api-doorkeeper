# frozen_string_literal: true

require 'namespaced_authorizing_processor'

JSONAPI.configure do |config|
  # using a customer authorizing processor that applied namespace to all policies
  config.default_processor_klass = NamespacedAuthorizingProcessor
  config.exception_class_whitelist = [JWTSessions::Errors::Unauthorized, Pundit::NotAuthorizedError]
end
