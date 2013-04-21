class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  before_filter :store_omniauth_data, :except => [:facebook_login, :twitter_login]

  def facebook
    if params[:state] && current_user
      save_token('facebook')
      redirect_to params[:state]
    else
      sign_in_or_register('facebook')
    end
  end

  def twitter
    if params[:state] && current_user
      save_token('twitter')
      redirect_to params[:state]
    else
      sign_in_or_register('twitter')
    end
  end

  def failure
    redirect_to params[:state]  
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
        logger.info 'ACCESS_TOKEN: '+params[:access_token]
        user = User.where('fbtoken.token' => omniauth_token, 'fbtoken.expires_at' => {'$gt' => DateTime.now.to_i}).first
      else
        user = User.where('twtoken.token' => omniauth_token).first
      end
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

  def save_token(provider)
    if provider == 'facebook'
      token                = Fbtoken.new 
      token.token          = omniauth_token
      token.expires_at     = omniauth_token_expires_at
      token.uid            = omniauth_uid
      current_user.fbtoken = token
    elsif provider == 'twitter'
      token                = Twtoken.new  
      token.token          = omniauth_token
      token.secret         = omniauth_secret
      current_user.twtoken = token
    end
    current_user.save
  end

end