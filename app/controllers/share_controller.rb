class ShareController < ActionController::Base

  respond_to :html, :json
  
  def share_event_appoint

    if params[:fb_share] == 'true'
      if current_user.fbtoken
        fb = Koala::Facebook::API.new(current_user.fbtoken.token)
        fb.put_wall_post("hey, i'm learning koala! lol")
      end
    end

    if params[:tw_share] == 'true'
      if current_user.twtoken
        tw = Twitter::Client.new(:consumer_key => "K8uuMWym0VKXWKcz7XJ0zQ",
                                 :consumer_secret => "NBjr9zz979n38fJgzaZF1v3ZTTIBEyExQmCmeIhavLM",
                                 :oauth_token => current_user.twtoken.token,
                                 :oauth_token_secret => current_user.twtoken.secret)
        Thread.new{tw.update("Tweeting from ebentum2")}
      end
    end
    
    render :json => true
  end
  
end
