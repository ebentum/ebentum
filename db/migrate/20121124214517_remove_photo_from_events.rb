class RemovePhotoFromEvents < ActiveRecord::Migration
  def up
    remove_column :events, :photo
  end

  def down
    add_column :events, :photo
  end
end
