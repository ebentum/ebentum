class Event
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip
  include Paperclip::Glue
  include Geocoder::Model::Mongoid
  include Mongoid::Slug

  slug do |cur_object|
    "#{cur_object.name}".parameterize
  end

  field :name, type: String
  field :description, type: String
  field :place, type: String
  field :active, type: Boolean
  field :start_date, type: DateTime
  field :coordinates, type: Array
  field :lat, type: BigDecimal
  field :lng, type: BigDecimal
  field :appointments_count, type: Integer, default: 0

  reverse_geocoded_by :coordinates

  attr_accessible :active, :description, :name, :place, :start_date, :lat, :lng #:photo
  # attr_readonly :appointments_count

  validates :name, :place, :start_date, :lat, :lng, presence: true

  belongs_to :creator, class_name: "User", inverse_of: :created_events

  has_one :main_picture, class_name: "EventPicture", as: :pictureable, dependent: :destroy

  has_and_belongs_to_many :users, inverse_of: :events
  has_many :comments, inverse_of: :event, dependent: :destroy


  def setCoordinates
    self.coordinates = [self.lng.to_f, self.lat.to_f]
    self.save
  end

  def calculate_appointments
    self.appointments_count = self.users.size
    self.save
  end

  def get_picture
    if self.main_picture?
      self.main_picture
    else
      EventPicture.new
    end
  end

  after_create do |event|
    Activity.new.fill_data("create", self.creator, self).save
  end

  after_update do |event|
    Activity.update_related_activities(event)
  end
  
  after_destroy do |event|
    Activity.destroy_related_activities(event)
  end

end
