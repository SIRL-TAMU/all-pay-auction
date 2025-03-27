class CreateStripeTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :stripe_transactions do |t|
      t.references :buyer, foreign_key: true, null: true # Optional association with buyers
      t.references :seller, foreign_key: true, null: true # Optional association with sellers
      t.decimal :amount, precision: 10, scale: 2, null: false # Transaction amount
      t.string :transaction_type, null: false # 'deposit' or 'withdraw'
      t.string :stripe_transaction_id # Stripe transaction ID for reference
      t.datetime :transaction_date, null: false # Actual transaction date/time
      t.timestamps # Includes created_at and updated_at
    end
  end
end