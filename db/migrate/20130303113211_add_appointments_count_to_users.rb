class AddAppointmentsCountToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :appointments_count, :integer, :default => 0

    # User.reset_column_information
    # User.find(:all).each do |p|
    #   p.update_attribute :appointments_count, p.appointments.length
    # end
  end

  def self.down
    remove_column :users, :appointments_count
  end
end