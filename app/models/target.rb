class Target
  include Mongoid::Document

  field :url, type: String
  field :objectType, type: String

  embedded_in :targetable, polymorphic: true
end
