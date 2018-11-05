# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/invitations_mailer
class InvitationsMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/invitations_mailer/set_password
  def set_password
    InvitationsMailer.set_password
  end
end
