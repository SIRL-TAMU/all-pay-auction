class ChangeDefaultEnum < ActiveRecord::Migration[7.2]
  def change
    change_column_default :auction_items, :item_type, 0
  end
end
