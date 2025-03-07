class AddVerificationTokenToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :buyers, :verification_token, :string
    add_column :sellers, :verification_token, :string
  end
end
