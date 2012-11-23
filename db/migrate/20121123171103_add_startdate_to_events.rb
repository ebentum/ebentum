class AddStartdateToEvents < ActiveRecord::Migration
  def change
    add_column :events, :start_date, :date
    add_column :events, :start_time, :time
  end
end
