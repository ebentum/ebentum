class Twtoken
  include Mongoid::Document
  include Mongoid::Timestamps

  field :token, type: String
  field :secret, type: String
  field :autopublish, type: Boolean, default: false
  field :uid, type: String

  attr_accessible :token, :secret, :autopublish, :uid

  embedded_in :user
  
end
