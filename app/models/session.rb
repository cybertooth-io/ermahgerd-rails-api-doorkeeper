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

  # Relationships
  # --------------------------------------------------------------------------------------------------------------------

  belongs_to :invalidated_by, class_name: 'User', optional: true

  belongs_to :user
end
