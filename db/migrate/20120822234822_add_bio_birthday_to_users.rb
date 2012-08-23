class AddBioBirthdayToUsers < ActiveRecord::Migration
  def change
    add_column :users, :bio, :string
    add_column :users, :birthday, :string
  end
end
