class AddEventsCountToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :events_count, :integer, :default => 0

    # User.reset_column_information
    # User.find(:all).each do |p|
    #   p.update_attribute :events_count, p.events.length
    # end
  end

  def self.down
    remove_column :users, :events_count
  end
end