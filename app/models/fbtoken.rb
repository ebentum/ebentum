class Fbtoken < ActiveRecord::Base

  attr_accessible :token, :expires_at 
  
  # id del token si lo tiene 0 si no
  def self.access_token_id(user_id)
    token = self.find_by_user_id(user_id)
    if token
      token.id
    else
      0
    end  
  end

end
