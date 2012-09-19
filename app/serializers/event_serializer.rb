class EventSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :photo
end
