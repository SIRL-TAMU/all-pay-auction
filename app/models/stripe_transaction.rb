class StripeTransaction < ApplicationRecord
    belongs_to :buyer, optional: true
    belongs_to :seller, optional: true
  
    enum transaction_type: { deposit: 'deposit', withdraw: 'withdraw' }
  
    validates :amount, presence: true, numericality: { greater_than: 0 }
    validates :transaction_type, presence: true
    #validates :stripe_transaction_id, presence: true, uniqueness: true # unsure on this part for now
  
    validate :belongs_to_one_party
  
    private
  
    def belongs_to_one_party
      if buyer.present? && seller.present?
        errors.add(:base, "Transaction cannot belong to both buyer and seller")
      elsif buyer.blank? && seller.blank?
        errors.add(:base, "Transaction must belong to either buyer or seller")
      end
    end
  end
  