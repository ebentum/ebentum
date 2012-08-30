class Event < ActiveRecord::Base
  attr_accessible :active, :description, :name, :place, :start_datetime, :user_id
  
  has_many :appointments
  belongs_to :user 
  has_many :users, :through => :appointments 
  
end
