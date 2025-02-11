# frozen_string_literal: true

# Base model class for all ActiveRecord models.
# Other models should inherit from this class to share common configurations.
class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  layout "mailer"
end
