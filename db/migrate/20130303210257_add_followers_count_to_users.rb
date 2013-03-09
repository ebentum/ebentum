class AddFollowersCountToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :followers_count, :integer, :default => 0

    # User.reset_column_information
    # User.find(:all).each do |p|
    #   p.update_attribute :followers_count,  p.followers.length
    # end
  end

  def self.down
    remove_column :users, :followers_count
  end
end