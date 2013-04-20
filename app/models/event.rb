class Event
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip

  field :name, type: String
  field :description, type: String
  field :place, type: String
  field :active, type: Boolean
  field :start_date, type: Date
  field :start_time, type: Time
  field :photo_file_name, type: String
  field :photo_content_type, type: String
  field :photo_file_size, type: Integer
  field :photo_updated_at, type: DateTime
  field :lat, type: BigDecimal
  field :lng, type: BigDecimal
  field :appointments_count, type: Integer

  attr_accessible :active, :description, :name, :place, :start_date, :start_time, :photo, :lat, :lng
  attr_readonly :appointments_count

  validates :name, :place, :start_date, :start_time, :lat, :lng, presence: true

  belongs_to :creator, class_name: "User", inverse_of: :created

  embeds_one :main_picture, class_name: "Picture", as: :pictureable

  has_and_belongs_to_many :users, inverse_of: :events
  has_many :comments, inverse_of: :event

  has_mongoid_attached_file  :photo, :styles => { :small => "300x300>", :medium => "600x600>" }


  after_create do |event|
    activity = Activity.new
    activity.verb = "create"

    activity.actor = Actor.new
    activity.actor.url = Rails.application.routes.url_helpers.user_path(self.creator)
    activity.actor.objectType = "user"
    activity.actor.displayName = self.creator.complete_name
    activity.actor.photoUrl = self.creator.image.url(:thumb)
  
    activity.subject = Subject.new
    activity.subject.objectType = "event"
    activity.subject.url = Rails.application.routes.url_helpers.event_path(self)
    activity.subject.displayName = self.name
    activity.subject.photoUrl = self.photo.url(:medium)
    activity.subject.address = self.place
    activity.subject.startDate = self.start_date
    activity.subject.startTime = self.start_time

    activity.save
  end
end
