class AddAppointmentsCountToEvents < ActiveRecord::Migration
  def change
    add_column :events, :appointments_count, :number
  end
end
