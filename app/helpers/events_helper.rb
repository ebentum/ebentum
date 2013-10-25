module EventsHelper

  def event_picture(event)
    if event.main_picture?
      event.main_picture
    else
      EventPicture.new
    end
  end

end
