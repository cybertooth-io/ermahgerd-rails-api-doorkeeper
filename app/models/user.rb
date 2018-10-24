# frozen_string_literal: true

# The `User` model.  Email validations in effect.  Uses `has_secure_password` to accept `password` &
# `password_confirmation` arguments when creating or updating a password.  Never interact directly with
# the `password_digest` column.
class User < ApplicationRecord
  has_secure_password

  # Validations
  # --------------------------------------------------------------------------------------------------------------------

  validates :email, :first_name, :last_name, presence: true

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  # Relationships
  # --------------------------------------------------------------------------------------------------------------------

  has_and_belongs_to_many :roles

  has_many :sessions

  # Scopes
  # --------------------------------------------------------------------------------------------------------------------

  scope :by_id, ->(ids) { where id: ids }

  # Pundit Helpers
  # --------------------------------------------------------------------------------------------------------------------

  def administrator?
    roles.exists?(key: 'ADMIN')
  end

  def guest?
    roles.exists?(key: 'GUEST')
  end
end
