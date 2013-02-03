class RenameTokens < ActiveRecord::Migration
  def self.up
    rename_table :tokens, :fbtokens
  end 
  def self.down
      rename_table :fbtokens, :tokens
  end
end