class Actor
  include Mongoid::Document

  field :url, type: String
  field :objectType, type: String

  embedded_in :actorable, polymorphic: true
end
