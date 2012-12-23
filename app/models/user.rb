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
  attr_accessible :email, :password, :password_confirmation, :remember_me, :complete_name, :provider, :uid
  # attr_accessible :email, :encrypted_password
  
  has_many :appointments
  has_many :followings
  has_many :events, :through => :appointments

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.new(complete_name:auth.extra.raw_info.name,
                         provider:auth.provider,
                         uid:auth.uid,
                         email:auth.info.email,
                         password:Devise.friendly_token[0,20]
                         )
      user.skip_confirmation! # si viene de facebook ya está confirmado
      user.save!
    end
    user
  end
  
end
