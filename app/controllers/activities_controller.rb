class ActivitiesController < ApplicationController

  def index
    @last_activity_date = params[:last_activity_date]
    @activities = ActivityStream.user_activity_stream(current_user, @last_activity_date)

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
