class AddProviderAndUidToSellers < ActiveRecord::Migration[7.2]
  def change
    add_column :sellers, :provider, :string
    add_column :sellers, :uid, :string
  end
end
