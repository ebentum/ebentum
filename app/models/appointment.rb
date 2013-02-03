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

  after_create do |event|
    @activity = Activity.new(:user_id => self.user_id, :event_id => self.event_id, :action => 'JOIN')
    @activity.save
  end

  def self.user_appointment_id(event_id, user_id)
    appoint = Appointment.where(:event_id => event_id, :user_id => user_id).first
    if appoint != nil
      appoint.id
    else
      0
    end
  end

end
