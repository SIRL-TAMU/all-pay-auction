# rubocop:disable all
class AddUniqueIndexToUsers < ActiveRecord::Migration[7.2]
  def change
    add_index :buyers, %i[uid provider], unique: true, where: "uid IS NOT NULL"
    add_index :sellers, %i[uid provider], unique: true, where: "uid IS NOT NULL"
  end
end

# rubocop:enable all