class AddFollowedUsersCountToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :followed_users_count, :integer, :default => 0

    # User.reset_column_information
    # User.find(:all).each do |p|
    #   p.update_attribute :followed_users_count, p.followed_users.length
    # end
  end

  def self.down
    remove_column :users, :followed_users_count
  end
end