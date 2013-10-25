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

  has_one :main_picture, class_name: "EventPicture", as: :pictureable, dependent: :destroy

  has_and_belongs_to_many :users, inverse_of: :events
  has_many :comments, inverse_of: :event, dependent: :destroy

  def setCoordinates
    self.coordinates = [self.lng.to_f, self.lat.to_f]
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

end
