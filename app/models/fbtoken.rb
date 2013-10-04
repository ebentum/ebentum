class Fbtoken
  include Mongoid::Document
  include Mongoid::Timestamps

  field :token, type: String
  field :expires_at, type: Integer
  field :autopublish, type: Boolean, default: false
  field :uid, type: String

  attr_accessible :token, :expires_at, :autopublish, :uid

  embedded_in :user

end
