class AddAutopublishToTwtokens < ActiveRecord::Migration
  def change
    add_column :twtokens, :autopublish, :boolean
  end
end
