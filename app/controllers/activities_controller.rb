class ActivitiesController < ApplicationController

  def index
    @page     = params[:page] || 1
    @activities = current_user.activities.page(@page)

    if request.xhr?
      js_callback false
    end

    respond_to do |format|
      format.html { render :layout => nil if request.xhr? }
      format.json { render json: @activities }
    end
  end

end
