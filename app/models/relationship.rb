class Relationship < ActiveRecord::Base

  attr_accessible :followed_id, :follower_id

  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  validates :follower_id, presence: true
  validates :followed_id, presence: true


  after_create :increment_counter_cache
  after_destroy :decrement_counter_cache

  private

  def increment_counter_cache
    self.follower.followed_users_count += 1
    self.followed.followers_count += 1
    self.follower.save
    self.followed.save
  end


  def decrement_counter_cache
    self.follower.followed_users_count -= 1
    self.followed.followers_count -= 1
    self.follower.save
    self.followed.save
  end

end

