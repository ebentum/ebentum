class ActivitiesController < ApplicationController

  def index
    @activities = current_user.activities
    respond_to do |format|
      format.html
      format.json { render json: @activities }
    end
  end

end
