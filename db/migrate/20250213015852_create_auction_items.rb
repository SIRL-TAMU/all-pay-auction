class CreateAuctionItems < ActiveRecord::Migration[7.2]
  def change
    create_table :auction_items do |t|
      t.references :seller, null: false, foreign_key: true
      t.string :name
      t.text :description
      t.decimal :max_bid
      t.datetime :opening_date
      t.datetime :closing_date
      t.string :image

      t.timestamps
    end
  end
end
