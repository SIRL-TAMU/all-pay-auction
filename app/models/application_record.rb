# frozen_string_literal: true

# Base mailer class for the application. Other mailers should inherit from this class.
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end
