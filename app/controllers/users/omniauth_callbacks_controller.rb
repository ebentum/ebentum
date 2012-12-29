class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  before_filter :store_omniauth_data

  def facebook
    redirect_to new_user_registration_url
  end

  def store_omniauth_data
    flash[:omniauth_data] = request.env["omniauth.auth"]
  end

end