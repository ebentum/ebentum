class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :body, type: String

  belongs_to :creator, class_name: "User"
  
  belongs_to :event, inverse_of: :comments

end
