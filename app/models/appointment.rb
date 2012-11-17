# == Schema Information
#
# Table name: appointments
#
#  id         :integer          not null, primary key
#  event_id   :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Appointment < ActiveRecord::Base
  attr_accessible :event_id, :user_id
  
  belongs_to :user 
  belongs_to :event 
  
end
