class Api::V1::Protected::UserResource < JSONAPI::Resource

  # Attributes
  # --------------------------------------------------------------------------------------------------------------------

  attributes(
      :created_at,
      :email,
      :first_name,
      :last_name,
      :nickname,
      :updated_at,
      {}
  )

  # Relationships
  # --------------------------------------------------------------------------------------------------------------------

  has_many :sessions
end
