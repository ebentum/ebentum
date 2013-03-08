class Activity < ActiveRecord::Base
  attr_accessible :action, :event_id, :user_id
  
  belongs_to :event
  belongs_to :user
end
