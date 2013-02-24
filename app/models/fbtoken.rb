class Fbtoken < ActiveRecord::Base

  attr_accessible :token, :expires_at, :user_id 

  belongs_to :user 
  
  # devuelve el token si lo tiene nil si no
  def self.get_access_token(user_id)
    token = self.find_by_user_id(user_id)
    if token
      token
    else
      nil
    end  
  end

end
