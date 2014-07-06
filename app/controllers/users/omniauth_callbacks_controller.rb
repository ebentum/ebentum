class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  skip_before_filter :auth_user
  before_filter :store_omniauth_data, :except => [:facebook_login, :twitter_login]
  before_filter :koala_facebook_oauth, :only => [:facebook, :facebook_login]


  def facebook
    if params[:state] && current_user
      if save_token('facebook')
        redirect_to edit_user_registration(current_user)
      else
        redirect_to edit_user_registration(current_user)+'?already_linked=true'
      end
    elsif session[:token_renew]
      session.delete(:token_renew)
      renew_fbtoken_and_login
    else
      sign_in_or_register('facebook')
    end
  end

  def twitter
    if params[:state] && current_user
      if save_token('twitter')
        redirect_to edit_user_registration(current_user)
      else
        redirect_to edit_user_registration(current_user)+'?already_linked=true'
      end
    else
      sign_in_or_register('twitter')
    end
  end

  def failure
    if params[:state]
      # redirect_to params[:state]
      redirect_to welcome_index_path
    else
      redirect_to welcome_index_path
    end
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
      redirect_to '/users/auth/twitter?use_authorize=true&state='+params[:state]
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
        begin
          token = @oauth.get_access_token(params[:code])
        rescue Koala::Facebook::OAuthTokenRequestError
          session[:token_renew] = true
          redirect_to @oauth.url_for_oauth_code
          return
        else
          fb   = Koala::Facebook::API.new(token)
          me   = fb.get_object("me")
          user = User.where('fbtoken.uid' => me['id']).first
        end
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
      # si existe un usuario con ese uid en el token no le dejamos vincular esa cuenta de tw/fb de nuevo a ebentum
      if provider == 'facebook'
        user = User.where('fbtoken.uid' => omniauth_uid)
      else
        user = User.where('twtoken.uid' => omniauth_uid)
      end
      if user.size > 0
        # eliminamos la información de omniauth
        flash[:omniauth_data] = nil
        # indicamos que esa cuenta ya está vinculada
        flash[:account_linked] = provider
      end
      redirect_to new_user_registration_url
    end
  end

  def renew_fbtoken_and_login
    # pedimos el token
    token_info = @oauth.get_access_token_info(params[:code])
    token      = token_info["access_token"]
    expires_at = DateTime.now.to_i + token_info["expires"].to_i
    # obtenemos el usuario propietario de ese token
    fb   = Koala::Facebook::API.new(token)
    me   = fb.get_object("me")
    user = User.where('fbtoken.uid' => me['id']).first
    # le actualizamos el token y la expiración
    user.update_fbtoken(token, expires_at)
    # logueamos y vamos al inicio
    sign_in(:user, user)
    redirect_to root_url
  end

  def save_token(provider)
    # comprobamos si ese esta cuenta ya está linkada
    if provider == 'facebook'
      user = User.where('fbtoken.uid' => omniauth_uid)
    else
      user = User.where('twtoken.uid' => omniauth_uid)
    end
    if user.size == 0
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
        token.uid            = omniauth_uid
        current_user.twtoken = token
      end
      current_user.save
      return true
    else # ya hay un usuario que tiene esa cuenta vinculada
      return false
    end
  end

  def koala_facebook_oauth
    @oauth = Koala::Facebook::OAuth.new(ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET'], 'http://www.ebentum.com/auth_login/callback')
  end

end