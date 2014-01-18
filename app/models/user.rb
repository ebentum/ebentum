class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip
  include Mongo::Followable::Followed
  include Mongo::Followable::Follower
  include Mongo::Followable::History
  include Mongoid::FullTextSearch

  devise :database_authenticatable,
         #:token_authenticatable,
         :omniauthable,
         :confirmable,
         :recoverable,
         :registerable,
         :rememberable,
         :trackable,
         #:timeoutable,
         :validatable
         #:lockable

  field :username, type: String
  field :complete_name, type: String
  field :location, type: String
  field :web, type: String
  field :bio, type: String
  field :active, type: Boolean
  field :coordinates, type: Array
  field :lat, type: BigDecimal
  field :lng, type: BigDecimal

  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""

  validates_presence_of :encrypted_password
  validates_presence_of :complete_name
  validates_presence_of :password, :password_confirmation

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Confirmable
  field :confirmation_token,   :type => String
  field :confirmed_at,         :type => Time
  field :confirmation_sent_at, :type => Time
  field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Omniauthable
  field :provider,  :type => String
  field :uid,       :type => String

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :complete_name, :location, :bio, :web, :provider, :uid, :lat, :lng#, :image, :image_url, :image_delete

  # atributos que no son del modelo
  # email que viene de omniauth
  attr_accessor   :omniauth_email
  attr_accessible :omniauth_email
  # si el usuario requiere confirmación de email true/false
  attr_accessor   :user_confirmation_required
  attr_accessible :user_confirmation_required

  has_many :created_events, class_name: "Event", inverse_of: :creator, dependent: :destroy

  has_many :created_pictures, class_name: "Picture", inverse_of: :creator, dependent: :destroy

  has_and_belongs_to_many :events, inverse_of: :users
  embeds_one :fbtoken
  embeds_one :twtoken

  has_and_belongs_to_many :activities, inverse_of: :receivers,  order: 'created_at DESC', dependent: :destroy, index: true

  has_one :main_picture, class_name: "UserPicture", as: :pictureable, dependent: :destroy

  has_many :comments, inverse_of: :creator, dependent: :destroy

  fulltext_search_in :complete_name

  # renovación de token de acceso a Facebook
  def update_fbtoken(token, expires_at)
    self.fbtoken.token      = token
    self.fbtoken.expires_at = expires_at
    self.fbtoken.updated_at = DateTime.now
    self.update
  end

  # override de la función de devise para saber cuando debemos confirmar el email
  def confirmation_required?
    if self.confirmation_token != nil
      true
    else
      self.user_confirmation_required == 'true'
    end
  end

  def get_picture
    if self.main_picture?
      self.main_picture
    else
      UserPicture.new
    end
  end

  after_update do |user|
    Activity.update_related_activities(user)
  end

  after_destroy do |user|
    Activity.destroy_related_activities(user)

    #TODO Estoy hay que mejorarlo con una relación
    Comment.where("creator._id" => user._id).entries.each do |comment|
      comment.destroy
    end

  end

  def setCoordinates
    self.coordinates = [self.lng.to_f, self.lat.to_f]
    self.save
  end

end
