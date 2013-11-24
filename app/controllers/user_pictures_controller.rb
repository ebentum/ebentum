class UserPicturesController < PicturesController
  before_filter :get_image

  private

  def get_image
    if action_name == 'create'
      @picture = UserPicture.new(params[:user_picture])
    else
      @picture = UserPicture.find(params[:id])
      @new_picture_params = params[:user_picture]
    end
  end
end
