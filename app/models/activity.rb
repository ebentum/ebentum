class Activity
  include Mongoid::Document
  include Mongoid::Timestamps

  field :verb, type: String

  embeds_one :actor
  embeds_one :subject
  embeds_one :target
  has_and_belongs_to_many :receivers, class_name: "User", inverse_of: :activities

end