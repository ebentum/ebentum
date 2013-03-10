# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  username               :string(255)
#  complete_name          :string(255)
#  location               :string(255)
#  web                    :string(255)
#  bio                    :text
#  active                 :boolean
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  provider               :string(255)
#  uid                    :string(255)
#  image_file_name        :string(255)
#  image_content_type     :string(255)
#  image_file_size        :integer
#  image_updated_at       :datetime
#  image_url              :string(255)
#

class User < ActiveRecord::Base
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

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :complete_name, :location, :bio, :web, :provider, :uid, :image, :image_url

  validates :complete_name, :presence => true

  # atributos que no son del modelo
  # email que viene de omniauth
  attr_accessor   :omniauth_email
  attr_accessible :omniauth_email
  # si el usuario requiere confirmación de email true/false
  attr_accessor   :user_confirmation_required
  attr_accessible :user_confirmation_required

  has_many :appointments

  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy

  has_many :followed_users, through: :relationships, source: :followed
  has_many :followers, through: :reverse_relationships, source: :follower

  has_many :events, :through => :appointments
  has_many :joined_events, :through => :appointments , :source => :event
  
  has_many :activities

  has_one :fbtoken
  has_one :twtoken

  has_attached_file :image, :styles => {:thumb => "100x100#",  :small => "300x300>", :medium => "600x600>" }

  # override de la función de devise para saber cuando debemos confirmar el email
  def confirmation_required?
    self.user_confirmation_required == 'true'
  end

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end

  def image_path
    self.image_url || self.image.url(:small)  
  end

end
