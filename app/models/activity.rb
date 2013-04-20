class Activity
  include Mongoid::Document
  include Mongoid::Timestamps

  field :verb, type: String

  embeds_one :actor
  embeds_one :subject
  embeds_one :target
end