# == Schema Information
#
# Table name: events
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  description        :text
#  place              :string(255)
#  user_id            :integer
#  active             :boolean
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  start_date         :date
#  start_time         :time
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  lat                :decimal(10, 6)
#  lng                :decimal(10, 6)
#

class Event < ActiveRecord::Base
  attr_accessible :active, :description, :name, :place, :start_date, :start_time, :user_id, :photo, :lat, :lng
  attr_readonly :appointments_count

  validates :name, :place, :start_date, :start_time, :user_id, :lat, :lng, :presence => true

  has_many :appointments
  belongs_to :user  , :counter_cache => true
  has_many :users, :through => :appointments 
  
  has_many :activities

  has_attached_file :photo, :styles => { :small => "300x300>", :medium => "600x600>" }


  after_create do |event|
    @activity = Activity.new(:user_id => self.user_id, :event_id => self.id, :action => 'CREATE')
    @activity.save
  end

end
