module UsersHelper
  
  def user_picture(user)
    if user.main_picture?
      user.main_picture
    else
      Picture.new
    end
  end

end
