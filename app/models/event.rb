# == Schema Information
#
# Table name: events
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  description    :text
#  start_datetime :datetime
#  place          :string(255)
#  user_id        :integer
#  active         :boolean
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  photo          :string(255)
#

class Event < ActiveRecord::Base
  attr_accessible :active, :description, :name, :place, :start_datetime, :user_id, :photo
  
  has_many :appointments
  belongs_to :user 
  has_many :users, :through => :appointments 
  
end
