module ActivitiesHelper

  def create_user_event_activity(verb, actor, subject)

    activity = Activity.new
    activity.verb = verb

    activity.actor = Actor.new
    activity.actor._id = actor._id
    activity.actor.url = Rails.application.routes.url_helpers.user_path(actor)
    activity.actor.objectType = "user"
    activity.actor.displayName = actor.complete_name

    activity.actor.photoUrl = user_picture(actor).photo.url(:thumb)
    #else
    #  activity.actor.photoUrl = "/photos/thumb/missing_user.png"


    activity.subject = Subject.new
    activity.subject._id = subject._id
    activity.subject.objectType = "event"
    activity.subject.url = Rails.application.routes.url_helpers.event_path(subject)
    activity.subject.displayName = subject.name
    if !subject.main_picture.nil?
      activity.subject.photoUrl = event_picture(subject).photo.url(:card)
      activity.subject.photoWidth = subject.main_picture.photo_dimensions["card"][0]
      activity.subject.photoHeight = subject.main_picture.photo_dimensions["card"][1]
    else
      activity.subject.photoUrl = event_picture(subject).photo.url(:card)
    end
    activity.subject.address = subject.place
    activity.subject.startDate = subject.start_date
    activity.subject.startTime = subject.start_time

    activity.receivers = actor.all_followers
    activity.receivers.push(actor)

    activity.save

  end

end
