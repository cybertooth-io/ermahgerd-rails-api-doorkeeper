# frozen_string_literal: true

# A `Session` represents all of the sign in information collected from an authenticated user.
# The `RUID` is what binds the session information stored in the database with what is stored inside of Redis
# by `JWTSessions`.
class Session < ApplicationRecord
  # Validations
  # --------------------------------------------------------------------------------------------------------------------

  validates(
    :browser,
    :browser_version,
    :device,
    :expiring_at,
    :ip_address,
    :platform,
    :platform_version,
    :ruid,
    :user,
    presence: true
  )

  # boolean presence check...crazy I know (http://stackoverflow.com/a/4721574/545137)
  validates :invalidated, inclusion: { in: [true, false] }

  # TODO: validate that you can only invalidate sessions that aren't already invalidated
  # TODO: validate that :update includes the `invalidated_by` field

  # Relationships
  # --------------------------------------------------------------------------------------------------------------------

  belongs_to :invalidated_by, class_name: 'User', optional: true

  belongs_to :user

  # Scopes
  # --------------------------------------------------------------------------------------------------------------------

  scope :by_user, ->(ids) { where user_id: ids }
end
