# frozen_string_literal: true

# Controller concern that can be used to provide a `current_user` method that will return a reference to
# the authenticated `User` instance whose `Role` relations are included.
#
# The `User` instance is placed in the `@current_user` member variable.
#
# There is nothing stopping an implementor from changing this to return a JSON representation
# of this user that is stored inside the JWT access token.
module CurrentUser
  extend ActiveSupport::Concern
  included do
    private

    # The current_user can be found in the JWT payload; eagerly load the user's roles so they can be discriminated
    # against
    def current_user
      @current_user ||= User.includes(:roles).find_by(id: payload['user_id'])
    end
  end
end
