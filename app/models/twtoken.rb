class Twtoken < ActiveRecord::Base

  attr_accessible :token, :secret, :user_id

  belongs_to :user
  
  # devuelve el token si lo tiene nil si no
  def self.get_access_token(user)
    if user
      token = self.find_by_user_id(user.id)
      if token
        token
      else
        nil
      end
    else
      nil
    end  
  end
  
end
