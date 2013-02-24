class ShareController < ActionController::Base

  respond_to :html, :json
  
  def share_event_appoint
    # generar el contenido a compartir
    event     = Event.find(params[:event_id])
    event_url = 'www.ebentum.com/events/'+event.id.to_s
    message   = t(:share_message, :event_name => event.name, :event_url => event_url)

    if params[:fb_share] == 'true'
      if current_user.fbtoken
        fb = Koala::Facebook::API.new(current_user.fbtoken.token)
        fb.put_wall_post(message)
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
  
end
