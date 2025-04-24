class AddStripeAccountIdToSellers < ActiveRecord::Migration[7.2]
  def change
    add_column :sellers, :stripe_account_id, :string
  end
end
