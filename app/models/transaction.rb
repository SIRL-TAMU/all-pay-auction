# frozen_string_literal: true

# Represents a financial transaction related to auction sales
class Transaction < ApplicationRecord
  belongs_to :buyer
  belongs_to :seller
end
