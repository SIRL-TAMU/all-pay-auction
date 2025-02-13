class CreateTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :transactions do |t|
      t.references :buyer, null: false, foreign_key: true
      t.references :seller, null: false, foreign_key: true
      t.decimal :amount
      t.boolean :is_credit
      t.boolean :is_buyer
      t.datetime :created_date

      t.timestamps
    end
  end
end
