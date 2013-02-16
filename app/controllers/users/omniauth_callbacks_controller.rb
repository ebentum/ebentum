class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  before_filter :store_omniauth_data, :except => [:facebook_login, :twitter_login]

  def facebook
    if params[:state] && current_user
      save_fbtoken
      redirect_to params[:state]
    else
      sign_in_or_register('facebook')
    end
  end

  def twitter
    if params[:state] && current_user
      save_twtoken
      redirect_to params[:state]
    else
      sign_in_or_register('twitter')
    end
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
    if params[:state]
      redirect_to '/users/auth/twitter?state='+params[:state]  
    else
      redirect_to '/users/auth/twitter'
    end
  end

  def store_omniauth_data
    if request.env["omniauth.auth"] #solo accedemos a los datos si los hay, a veces hay errores.
      flash[:omniauth_data] = request.env["omniauth.auth"].except('extra')  
    end
  end

  private

  def sign_in_or_register(provider)
    if session[:islogin]
      session.delete(:islogin)
      if provider == 'facebook'
        token = Fbtoken.find_by_token(omniauth_token)
      else
        token = Twtoken.find_by_token(omniauth_token)
      end
      if token
        sign_in(:user, User.find_by_id(token.user_id))
        redirect_to root_url
      else
        redirect_to new_user_registration_url
      end
    else
      redirect_to new_user_registration_url
    end 
  end

  def save_fbtoken
    token             = Fbtoken.new
    token.token       = omniauth_token
    token.expires_at  = omniauth_token_expires_at
    token.user_id     = current_user.id
    token.autopublish = false
    token.save
  end

  def save_twtoken
    token             = Twtoken.new
    token.token       = omniauth_token
    token.secret      = omniauth_secret
    token.user_id     = current_user.id
    token.autopublish = false
    token.save
  end

end