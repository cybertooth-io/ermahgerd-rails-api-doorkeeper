# frozen_string_literal: true

# The `User` model.  Email validations in effect.  Uses `has_secure_password` to accept `password` &
# `password_confirmation` arguments when creating or updating a password.  Never interact directly with
# the `password_digest` column.
class User < ApplicationRecord
  has_secure_password
  audited

  # Callbacks
  # --------------------------------------------------------------------------------------------------------------------

  before_destroy do
    roles.clear
  end

  # Auto-Strip
  # --------------------------------------------------------------------------------------------------------------------

  auto_strip_attributes(
    :email,
    :first_name,
    :last_name,
    :nickname
  )

  # Validations
  # --------------------------------------------------------------------------------------------------------------------

  validates :email, :first_name, :last_name, presence: true

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :password, length: { minimum: 8 }

  # If you want to use `strong_password` gem (https://github.com/bdmac/strong_password)
  # Will need to uncomment it in the Gemfile & `bundle`
  # Defaults to minimum entropy of 18 and specifies that we want to use dictionary checking
  # validates :password, password_strength: { use_dictionary: true }

  # Relationships
  # --------------------------------------------------------------------------------------------------------------------

  # rubocop:disable Rails/HasAndBelongsToMany
  has_and_belongs_to_many :roles
  # rubocop:enable Rails/HasAndBelongsToMany

  has_many :sessions, dependent: :restrict_with_error

  # Scopes
  # --------------------------------------------------------------------------------------------------------------------

  # Pundit Helpers
  # --------------------------------------------------------------------------------------------------------------------

  def administrator?
    roles.exists?(key: 'ADMIN')
  end

  def guest?
    roles.exists?(key: 'GUEST')
  end
end
