class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    store_omniauth_data(request.env["omniauth.auth"])
    redirect_to new_user_registration_url
  end

end