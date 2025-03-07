class AddVerifiedToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :buyers, :verified, :boolean, default: false
    add_column :sellers, :verified, :boolean, default: false
  end
end
