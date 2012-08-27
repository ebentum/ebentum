class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.datetime :start_datetime
      t.string :place
      t.integer :user_id
      t.boolean :active

      t.timestamps
    end
  end
end
