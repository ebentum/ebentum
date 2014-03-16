class Activity < CouchRest::Model::Base
  use_database 'activities'

  property :verb, String
  property :actor_id, String
  property :object_type, String
  property :object_id, String
  property :receivers, [String]
  property :date, Time

end