# == Schema Information
#
# Table name: followings
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  following_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Following < ActiveRecord::Base
  attr_accessible :following_id, :user_id

  belongs_to :user
  belongs_to :follower, :class_name => 'user'

end
