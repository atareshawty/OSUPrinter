class AddLoginInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :cse_username, :string, null: false, default: ""
    add_column :users, :ece_username, :string, null: false, default: ""
    add_column :users, :cse_password, :string, null: false, default: ""
    add_column :users, :ece_password, :string, null: false, default: ""
  end
end
