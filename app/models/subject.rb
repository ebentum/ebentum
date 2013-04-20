class Subject
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip

  field :url, type: String
  field :objectType, type: String
  field :displayName, type: String
  field :photoUrl, type: String

  field :address, type: String
  field :startDate, type: Date
  field :startTime, type: Time

  embedded_in :activity
end