# frozen_string_literal: true

# The `SessionActivity` model is used to track authenticated resource access by time, IP, and session.
class SessionActivity < ApplicationRecord
  # Auto-Strip
  # --------------------------------------------------------------------------------------------------------------------

  auto_strip_attributes(
    :path
  )

  # Validations
  # --------------------------------------------------------------------------------------------------------------------

  validates(
    :ip_address,
    :path,
    :session,
    presence: true
  )

  # Relationships
  # --------------------------------------------------------------------------------------------------------------------

  belongs_to :session

  # Scopes
  # --------------------------------------------------------------------------------------------------------------------
end
