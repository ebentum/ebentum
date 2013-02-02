class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  before_filter :store_omniauth_data, :except => [:facebook_login, :twitter_login]

  def facebook
    if params[:state] && current_user
      current_user.update_social_fb(omniauth_provider, omniauth_uid)
      redirect_to params[:state]
    else
      sign_in_or_register
    end
  end

  def twitter
    sign_in_or_register
  end

  def facebook_login
    session[:islogin] = true
    if params[:state]
      redirect_to '/users/auth/facebook?state='+params[:state]  
    else
      redirect_to '/users/auth/facebook'
    end 
  end

  def twitter_login
    session[:islogin] = true
    redirect_to '/users/auth/twitter'
  end

  def store_omniauth_data
    if request.env["omniauth.auth"] #solo accedemos a los datos si los hay, a veces hay errores.
      flash[:omniauth_data] = request.env["omniauth.auth"].except('extra')  
    end
  end

  private

  def sign_in_or_register
    if session[:islogin]
      session.delete(:islogin)
      user = User.find_by_provider_and_uid(omniauth_provider, omniauth_uid)
      if user
        sign_in(:user, user)
        redirect_to root_url
      else
        redirect_to new_user_registration_url
      end
    else
      redirect_to new_user_registration_url
    end 
  end

end