class AddStripeAccountIdToBuyers < ActiveRecord::Migration[7.2]
  def change
    add_column :buyers, :stripe_account_id, :string
  end
end
