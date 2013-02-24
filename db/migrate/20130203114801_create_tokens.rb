class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.string :token
      t.integer :expires_at
      t.integer :user_id

      t.timestamps
    end
  end
end
