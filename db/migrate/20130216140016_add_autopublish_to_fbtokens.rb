class AddAutopublishToFbtokens < ActiveRecord::Migration
  def change
    add_column :fbtokens, :autopublish, :boolean
  end
end
