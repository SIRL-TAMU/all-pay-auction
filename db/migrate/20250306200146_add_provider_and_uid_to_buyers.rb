# rubocop:disable all
class AddProviderAndUidToBuyers < ActiveRecord::Migration[7.2]
  def change
    add_column :buyers, :provider, :string
    add_column :buyers, :uid, :string
  end
end

# rubocop:enable all