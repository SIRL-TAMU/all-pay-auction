# rubocop:disable all
class AddPasswordResetToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :buyers, :reset_password_token, :string
    add_column :buyers, :reset_password_sent_at, :datetime

    add_column :sellers, :reset_password_token, :string
    add_column :sellers, :reset_password_sent_at, :datetime

    add_index :buyers, :reset_password_token, unique: true
    add_index :sellers, :reset_password_token, unique: true
  end
end

# rubocop:enable all