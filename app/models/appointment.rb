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

  validates :event_id, :user_id, :presence => true
  
  belongs_to :user 
  belongs_to :event

  def self.appointment_exist(event_id, user_id)
    Appointment.where(:event_id => event_id, :user_id => user_id).size == 1
  end

end
