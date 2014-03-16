class ActivitiesController < ApplicationController

  def index

    #######
    fb = Koala::Facebook::API.new(current_user.fbtoken.token)
    users = User.where('fbtoken.uid' => fb.get_connections("me", "friends", :fields => "id, name, installed").select {|user| user.key?('installed')}.map {|installed| installed['id']})
    users.each {|user| logger.info user.email}
    ########

    @page     = params[:page] || 1
    @activities = current_user.activities.page(@page)

    if request.xhr?
      js_callback false
    end

    respond_to do |format|
      if request.xhr?
        format.html { render :layout => nil}
      else
        format.html { render :layout => 'fullwidth' }
      end
      format.json { render json: @activities }
    end
  end

end
