class UserPicturesController < PicturesController
  before_filter :get_image

  private

  def get_image
    if params[:action] = 'create'
      @picture = UserPicture.new(params[:user_picture])
    else
      @picture = UserPicture.find(params[:id])
    end
  end
end
