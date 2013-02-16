class Twtoken < ActiveRecord::Base

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
