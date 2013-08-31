module ActivitiesHelper

  def create_user_event_activity(verb, actor, subject)

    activity = Activity.new
    activity.verb = verb

    activity.actor = Actor.new
    activity.actor.url = Rails.application.routes.url_helpers.user_path(actor)
    activity.actor.objectType = actorType
    activity.actor.displayName = actor.complete_name
    activity.actor.photoUrl = actor.image.url(:thumb)

    activity.subject = Subject.new
    activity.subject.objectType = subjectType
    activity.subject.url = Rails.application.routes.url_helpers.event_path(subject)
    activity.subject.displayName = subject.name
    activity.subject.photoUrl = subject.main_picture.photo.url(:card)
    activity.subject.photoWidth = subject.main_picture.photo_dimensions["card"][0]
    activity.subject.photoHeight = subject.main_picture.photo_dimensions["card"][1]
    activity.subject.address = subject.place
    activity.subject.startDate = subject.start_date
    activity.subject.startTime = subject.start_time

    activity.receivers = actor.all_followers
    activity.receivers.push(actor)

    activity.save

  end

end
