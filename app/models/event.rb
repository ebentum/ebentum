class Event
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip
  include Paperclip::Glue
  include Geocoder::Model::Mongoid

  field :name, type: String
  field :description, type: String
  field :place, type: String
  field :active, type: Boolean
  field :start_date, type: Date
  field :start_time, type: Time
  field :coordinates, type: Array
  field :lat, type: BigDecimal
  field :lng, type: BigDecimal
  field :appointments_count, type: Integer

  reverse_geocoded_by :coordinates

  attr_accessible :active, :description, :name, :place, :start_date, :start_time, :lat, :lng #:photo
  attr_readonly :appointments_count

  validates :name, :place, :start_date, :start_time, :lat, :lng, presence: true

  belongs_to :creator, class_name: "User", inverse_of: :created

  has_one :main_picture, class_name: "Picture", as: :pictureable

  has_and_belongs_to_many :users, inverse_of: :events
  has_many :comments, inverse_of: :event

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
    activity.subject.photoUrl = self.main_picture.photo.url(:small)
    activity.subject.address = self.place
    activity.subject.startDate = self.start_date
    activity.subject.startTime = self.start_time

    activity.receivers = self.creator.all_followers
    activity.receivers.push(self.creator)

    activity.save
  end

  def setCoordinates
    self.coordinates = [self.lng.to_f, self.lat.to_f]
    self.save
  end

end
