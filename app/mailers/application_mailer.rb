# frozen_string_literal: true

# The application wide mailer that all mailers will inherit from
# Make sure to configure the layout accordingly
class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
end
