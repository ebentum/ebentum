class AddColumnsToUser < ActiveRecord::Migration
  def change
    add_column :users, :username, :string
    add_column :users, :complete_name, :string
    add_column :users, :location, :string
    add_column :users, :web, :string
    add_column :users, :bio, :text
    add_column :users, :active, :boolean
  end
end
