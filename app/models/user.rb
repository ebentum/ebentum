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
  
  has_many :appointments
  has_many :followings
  has_many :events, :through => :appointments

  # override de la función de devise para saber cuando debemos confirmar el email
  def confirmation_required?
    self.provider == nil
  end
  
end
