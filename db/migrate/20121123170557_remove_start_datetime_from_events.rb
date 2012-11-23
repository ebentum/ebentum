class RemoveStartDatetimeFromEvents < ActiveRecord::Migration
  def up
    remove_column :events, :start_datetime
  end

  def down
    add_column :events, :start_datetime
  end
end



