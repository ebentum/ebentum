class Fbtoken
  include Mongoid::Document
  include Mongoid::Timestamps

  field :token, type: String
  field :expires_at, type: Integer
  field :autopublish, type: Boolean

  attr_accessible :token, :expires_at

  embedded_in :user
  
  # devuelve el token si lo tiene nil si no
  # def self.get_access_token(user_id)
  #   token = self.find_by_user_id(user_id)
  #   if token
  #     token
  #   else
  #     nil
  #   end  
  # end

end
