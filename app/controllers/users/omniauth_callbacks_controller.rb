class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  before_filter :store_omniauth_data, :except => [:facebook_login, :twitter_login]
  before_filter :koala_facebook_oauth, :only => [:facebook, :facebook_login]


  def facebook
    if params[:state] && current_user
      save_token('facebook')
      redirect_to params[:state]
    else
      token = @oauth.get_access_token(params[:code])
      sign_in_or_register('facebook', token)
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
      redirect_to @oauth.url_for_oauth_code
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

  def sign_in_or_register(provider, token)
    if session[:islogin]
      session.delete(:islogin)
      if provider == 'facebook'
        fb = Koala::Facebook::API.new(token)
        me = fb.get_object("me")
        user = User.where('fbtoken.uid' => me['id'], 'fbtoken.expires_at' => {'$gt' => DateTime.now.to_i}).first
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

  def koala_facebook_oauth
    @oauth = Koala::Facebook::OAuth.new(ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET'], 'http://localhost:3000/auth_login/callback')
  end

end