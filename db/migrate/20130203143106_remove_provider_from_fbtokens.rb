class RemoveProviderFromFbtokens < ActiveRecord::Migration
  def up
    remove_column :fbtokens, :provider
  end

  def down
    add_column :fbtokens, :provider
  end
end
