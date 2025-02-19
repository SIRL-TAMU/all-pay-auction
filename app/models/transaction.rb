# frozen_string_literal: true

class Transaction < ApplicationRecord
  belongs_to :buyer
  belongs_to :seller
end
