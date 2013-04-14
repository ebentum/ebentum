class Subject
  include Mongoid::Document

  field :url, type: String
  field :objectType, type: String

  embedded_in :subjectable, polymorphic: true
end
