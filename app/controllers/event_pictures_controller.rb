class EventPicturesController < PicturesController
  before_filter :get_image

  private

  def get_image
    if params[:action] = 'create'
      @picture = EventPicture.new(params[:event_picture])
    else
      @picture = EventPicture.find(params[:id])
    end
  end
end
