# frozen_string_literal: true

# A very simple concern that provides the `by_id` scope to all models.
# Unit tested in the `User` model test.
module ScopeById
  extend ActiveSupport::Concern
  included do
    scope :by_id, ->(ids) { where id: ids }
  end
end
