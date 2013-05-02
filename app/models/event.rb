class Event
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip
  include Paperclip::Glue

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
  field :photo_dimensions, type: Hash
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

  has_mongoid_attached_file  :photo, :styles => { :small => "300x300>", :medium => "600x600>", :poster => Proc.new { |instance| instance.poster_resize } }

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
    activity.subject.photoUrl = self.photo.url(:small)
    activity.subject.address = self.place
    activity.subject.startDate = self.start_date
    activity.subject.startTime = self.start_time

    activity.receivers = self.creator.all_followers
    activity.receivers.push(self.creator)

    activity.save
  end

      # - pwidth = event.photo_dimensions["poster"][0]
      # - pheight = event.photo_dimensions["poster"][1] * 1.0
      # - if pwidth > 200
      #   -# lo que sobresale con respecto al ancho de una columna
      #   - pwidht_dif = (pwidth / 200.0) - (pwidth / 200)
      #   - if pwidht_dif < 0.25
      #     -#   -# redondear el ancho a la columna
      #     - pratio = pwidth / pheight
      #     - pwidth = ((pwidth / 200) * 200 ) + (((pwidth / 200)-1) * 10)
      #     - pheight = pwidth / pratio

      # -# - if pwidth > 200
      # -#   - pratio = pwidth / pheight
      # -#   -# redondear el ancho a columnas
      # -#   - pwidth = ((pwidth / 200).round) * 200
      # -#   - pheight = pwidth / pratio


  def poster_resize
     geo = Paperclip::Geometry.from_file(Paperclip.io_adapters.for(photo))

     ratio = geo.width/geo.height

     min_width  = 200
     min_height = 200

     if ratio > 1
       # Horizontal Image
       final_height = min_height
       final_width  = final_height * ratio

       if final_width > 200
        # lo que sobresale con respecto al ancho de una columna
        width_dif = (final_width / 200.0) - (final_width / 200)
        if width_dif < 0.25
          # redondear el ancho a la columna
          final_width = ((final_width / 200) * 200 )# + (((final_width / 200)-1) * 10)
          final_height = final_width / ratio
        end
      end

     else
       # Vertical Image
       final_width  = min_width
       final_height = final_width / ratio
     end

     "#{final_width.round}x#{final_height.round}!"
  end

end
