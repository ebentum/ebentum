class ShareController < ActionController::Base

  respond_to :html, :json
  
  def share_event_appoint
    if params[:fb_share]
      if current_user.fbtoken
        @api = Koala::Facebook::API.new(current_user.fbtoken.token)
        @api.put_wall_post("hey, i'm learning koala! lol")
      end
    end
    render :json => true
  end
  
end
