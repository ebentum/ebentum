class Activity
  include Mongoid::Document
  include Mongoid::Timestamps

  field :verb, type: String

  embeds_one :actor
  embeds_one :subject
  embeds_one :target
  has_and_belongs_to_many :receivers, class_name: "User", inverse_of: :activities


  def fill_data(verb, actor, subject, receivers = "followers")
    self.verb = verb

    self.add_object("actor", actor)
    self.add_object("subject", subject)

    if receivers == "followers"
      self.receivers = actor.all_followers
      self.receivers.push(actor)
    elsif receivers == "subject"
      self.receivers.push(subject)
    end 

    self
  end

  def add_object(type, object)
    object_type = object.class.name.downcase

    if type == "actor"
      self.actor = Actor.new
      self_object = self.actor
      self_object.photoUrl = object.get_picture.photo.url(:thumb)
    elsif type == "subject"
      self.subject = Subject.new
      self_object = self.subject
      self_object.photoUrl = object.get_picture.photo.url(:card)
      if !object.main_picture.nil?
        self_object.photoWidth = object.main_picture.photo_dimensions["card"][0]
        self_object.photoHeight = object.main_picture.photo_dimensions["card"][1]
      end
    end

    self_object._id = object._id
    self_object.objectType = object_type

    if object_type == "event"
      self_object.displayName = object.name
      self_object.url = Rails.application.routes.url_helpers.event_path(object)
      self_object.address = object.place
      self_object.startDate = object.start_date
      self_object.startTime = object.start_time
    elsif object_type == "user"
      self_object.url = Rails.application.routes.url_helpers.user_path(object)
      self_object.displayName = object.complete_name
    end
  end

end