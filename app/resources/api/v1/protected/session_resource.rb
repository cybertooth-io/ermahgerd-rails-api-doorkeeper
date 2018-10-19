class Api::V1::Protected::SessionResource < JSONAPI::Resource
  immutable # no CUD through controller

  # Attributes
  # --------------------------------------------------------------------------------------------------------------------

  # Notice that we're not serializing the RUID column; keep that hidden to the public
  attributes(
      :browser,
      :browser_version,
      :created_at,
      :device,
      :expiring_at,
      :invalidated,
      :ip_address,
      :platform,
      :platform_version,
      :updated_at,
      {}
  )

  # Relationships
  # --------------------------------------------------------------------------------------------------------------------

  has_one :invalidated_by

  has_one :user
end
