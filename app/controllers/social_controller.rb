require 'url_expander'

class SocialController < ActionController::Base

  respond_to :html, :json

  def share_event_appoint
    # generar el contenido a compartir
    event     = Event.find(params[:event_id])
    event_url = 'www.ebentum.com/events/'+event.id.to_s
    message   = t(:share_message, :event_name => event.name, :event_url => event_url)

    if params[:fb_share] == 'true'
      if current_user.fbtoken
        fb = Koala::Facebook::API.new(current_user.fbtoken.token)
        begin
          fb.put_wall_post(message)
        rescue Koala::Facebook::AuthenticationError
          renew_fbtoken
          # cargamos el graph API y publicamos
          fb = Koala::Facebook::API.new(current_user.fbtoken.token)
          fb.put_wall_post(message)
        end
      end
    end

    if params[:tw_share] == 'true'
      if current_user.twtoken
        tw = Twitter::Client.new(:oauth_token => current_user.twtoken.token, :oauth_token_secret => current_user.twtoken.secret)
        Thread.new{tw.update(message)}
      end
    end

    render :json => true
  end

  def get_social_data
    if params[:provider] == 'facebook'
      get_facebook_data
    else
      get_twitter_data
    end
  end

  def get_facebook_data
    fb = Koala::Facebook::API.new(current_user.fbtoken.token)
    begin
      me = fb.get_object("me")
    rescue Koala::Facebook::AuthenticationError
      renew_fbtoken
      # cargamos el graph API y consultamos
      fb = Koala::Facebook::API.new(current_user.fbtoken.token)
      me = fb.get_object("me")
    end
    picture = fb.get_picture(me['username'], :type => :large)
    render :json => {:complete_name => me['name'], :location => me['location']['name'], :web => me['website'], :bio => me['bio'], :image => picture}
  end

  def get_twitter_data
    tw = Twitter::Client.new(:oauth_token => current_user.twtoken.token, :oauth_token_secret => current_user.twtoken.secret)
    me = tw.verify_credentials
    render :json => {:complete_name => me.name, :location => me.location, :web => UrlExpander::Client.expand(me.url), :bio => me.description, :image => me.profile_image_url(:original)}
  end

  private

  def renew_fbtoken
    # renovamos el token
    oauth           = Koala::Facebook::OAuth.new(ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET'])
    new_access_info = oauth.exchange_access_token_info(current_user.fbtoken.token)
    token           = new_access_info["access_token"]
    expires_at      = DateTime.now.to_i + new_access_info["expires"].to_i
    # actualizamos el usuario
    current_user.update_fbtoken(token, expires_at)
  end

end
