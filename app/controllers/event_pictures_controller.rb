class EventPicturesController < PicturesController
  before_filter :get_image

  private

  def get_image
    if action_name == 'create'
      @picture = EventPicture.new(params[:event_picture])
    else
      @picture = EventPicture.find(params[:id])
      @new_picture_params = params[:event_picture]
    end
  end
end
