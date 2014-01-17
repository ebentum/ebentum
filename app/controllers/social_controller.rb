require 'url_expander'

class SocialController < ActionController::Base

  respond_to :html, :json

  def share_event_appoint
    # generar el contenido a compartir
    event     = Event.find(params[:event_id])
    event_url = 'http://www.ebentum.com/events/'+event.id.to_s
    message   = t(:share_message, :event_name => event.name)

    if params[:fb_share] == 'true'
      if current_user.fbtoken
        fb = load_graph_api
        picture = event.get_picture.photo.url(:small)
        if picture == '/photos/small/missing_event.png' # No hay imagen
          picture = 'https://s3-eu-west-1.amazonaws.com/ebentum.s3/system/logo.png'
        end
        begin
          fb.put_wall_post(message, {:name => event.name, :link => event_url, :caption => l(event.start_date, :format => :long), :description => event.description, :picture => event.get_picture.photo.url(:small)})
        rescue Koala::Facebook::AuthenticationError
          renew_fbtoken
          # cargamos el graph API y publicamos
          fb = load_graph_api
          fb.put_wall_post(message, {:name => event.name, :link => event_url, :caption => l(event.start_date, :format => :long), :description => event.description, :picture => event.get_picture.photo.url(:small)})
        end
      end
    end

    if params[:tw_share] == 'true'
      if current_user.twtoken
        url = Googl.shorten(event_url)
        tw = Twitter::Client.new(:oauth_token => current_user.twtoken.token, :oauth_token_secret => current_user.twtoken.secret)
        Thread.new{tw.update(message+' '+url.short_url)}
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
    fb = load_graph_api
    begin
      me = fb.get_object("me")
    rescue Koala::Facebook::AuthenticationError
      renew_fbtoken
      # cargamos el graph API y consultamos
      fb = load_graph_api
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

  def load_graph_api
    Koala::Facebook::API.new(current_user.fbtoken.token)
  end

end
