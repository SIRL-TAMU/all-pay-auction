class CreateAdmins < ActiveRecord::Migration[7.2]
  def change
    create_table :admins do |t|
      t.string :email, null: false
      t.decimal :asset_balance, null: false
      t.decimal :liquid_balance, null: false
      t.string :password_digest, null: false

      t.timestamps
    end
  end
end
