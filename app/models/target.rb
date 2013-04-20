class Target
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip

  field :url, type: String
  field :objectType, type: String
  field :displayName, type: String
  field :photoUrl, type: String

  embedded_in :activity
end