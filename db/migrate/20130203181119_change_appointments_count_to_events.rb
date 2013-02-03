class ChangeAppointmentsCountToEvents < ActiveRecord::Migration
  def change
    remove_column :events, :appointments_count
    add_column :events, :appointments_count, :integer
  end
end
