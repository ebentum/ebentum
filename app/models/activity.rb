class Activity
  include Streama::Activity

  activity :new_event do
    actor :user, :cache => [:complete_name]
    object :event
    #target_object :album, :cache => [:title]
  end

end