class User < ApplicationRecord

  has_secure_password


  # Validations
  # --------------------------------------------------------------------------------------------------------------------

  validates :email, :first_name, :last_name, presence: true

  validates :email, format: {with: URI::MailTo::EMAIL_REGEXP}


  # Relationships
  # --------------------------------------------------------------------------------------------------------------------

  has_many :sessions
end
