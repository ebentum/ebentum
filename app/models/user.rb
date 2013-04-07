class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip
  include Mongo::Followable::Followed
  include Mongo::Followable::Follower
  include Mongo::Followable::History
  include Streama::Actor

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

  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""

  validates_presence_of :email
  validates_presence_of :encrypted_password

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
  attr_accessible :email, :password, :password_confirmation, :remember_me, :complete_name, :location, :bio, :web, :provider, :uid, :image, :image_url, :image_delete

  validates :complete_name, :presence => true

  # atributos que no son del modelo
  # email que viene de omniauth
  attr_accessor   :omniauth_email
  attr_accessible :omniauth_email
  # si el usuario requiere confirmación de email true/false
  attr_accessor   :user_confirmation_required
  attr_accessible :user_confirmation_required

  has_many :created_events, class_name: "Event", inverse_of: :creator

  has_and_belongs_to_many :events, inverse_of: :users
  embeds_one :fbtoken
  embeds_one :twtoken

  has_mongoid_attached_file :image, :styles => {:thumb => "100x100",  :small => "300x300>", :medium => "600x600>" }

  before_save :destroy_image?

  def image_path(style = nil)
    _style = style || :medium
    uploaded_image_path = self.image.url(_style)
    if uploaded_image_path.include? "missing" and self.image_url
      self.image_url
    else
      uploaded_image_path
    end
  end

  # tratamiento de eliminacion de imagen de usuario y volver a la por defecto
  def image_delete
    @image_delete ||= "0"
  end

  def image_delete=(value)
    @image_delete = value
  end

  def destroy_image?
    self.image.clear if @image_delete == "1"
  end

  # override de la función de devise para saber cuando debemos confirmar el email
  def confirmation_required?
    self.user_confirmation_required == 'true'
  end

  def streama_followers
    self.all_followers
  end

end
