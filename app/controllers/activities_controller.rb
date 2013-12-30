class ActivitiesController < ApplicationController

  def index
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
