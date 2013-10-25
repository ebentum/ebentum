module ActivitiesHelper

  def create_user_event_activity(verb, actor, subject)

    activity = Activity.new
    activity.verb = verb

    activity.actor = Actor.new
    activity.actor._id = actor._id
    activity.actor.url = Rails.application.routes.url_helpers.user_path(actor)
    activity.actor.objectType = "user"
    activity.actor.displayName = actor.complete_name
    activity.actor.photoUrl = actor.get_picture.photo.url(:thumb)

    activity.subject = Subject.new
    activity.subject._id = subject._id
    activity.subject.objectType = "event"
    activity.subject.url = Rails.application.routes.url_helpers.event_path(subject)
    activity.subject.displayName = subject.name
    activity.subject.photoUrl = subject.get_picture.photo.url(:card)
    if !subject.main_picture.nil?
      activity.subject.photoWidth = subject.main_picture.photo_dimensions["card"][0]
      activity.subject.photoHeight = subject.main_picture.photo_dimensions["card"][1]
    end
    activity.subject.address = subject.place
    activity.subject.startDate = subject.start_date
    activity.subject.startTime = subject.start_time

    activity.receivers = actor.all_followers
    activity.receivers.push(actor)

    activity.save

  end

end
