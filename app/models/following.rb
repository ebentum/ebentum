class Following < ActiveRecord::Base
  attr_accessible :following_id, :user_id
  
  belongs_to :user 
  
end
