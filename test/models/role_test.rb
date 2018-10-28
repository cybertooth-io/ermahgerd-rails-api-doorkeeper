# frozen_string_literal: true

require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  test 'when creating a role the key will be capitalized' do
    role = Role.create(key: 'aBc', name: 'A B C')
    assert_equal 'ABC', role.key
  end
end
