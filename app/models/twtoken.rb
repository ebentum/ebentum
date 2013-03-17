class Twtoken
  include Mongoid::Document
  include Mongoid::Timestamps

  field :token, type: String
  field :secret, type: String
  field :autopublish, type: Boolean, default: false

  attr_accessible :token, :secret, :autopublish

  embedded_in :user
  
end
