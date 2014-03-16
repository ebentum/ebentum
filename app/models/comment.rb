class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :body, type: String

  belongs_to :creator, class_name: "User"
  
  belongs_to :event, inverse_of: :comments

  after_create do |event|

    Activity.new(
      :verb => "comment",
      :actor_id => self.creator.id,
      :object_type => "Event",
      :object_id => self.event.id,
      :receivers => self.creator.all_followers.map {|user| user.id},
      :date => Time.now
    ).save

  end

end
