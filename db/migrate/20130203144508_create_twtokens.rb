class CreateTwtokens < ActiveRecord::Migration
  def change
    create_table :twtokens do |t|
      t.string :token
      t.integer :secret
      t.integer :user_id

      t.timestamps
    end
  end
end
