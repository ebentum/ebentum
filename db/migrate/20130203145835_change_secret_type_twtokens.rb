class ChangeSecretTypeTwtokens < ActiveRecord::Migration
  def up
    change_table :twtokens do |t|
      t.change :secret, :string
    end
  end
  def down
    change_table :twtokens do |t|
      t.change :secret, :integer
    end
  end
end
