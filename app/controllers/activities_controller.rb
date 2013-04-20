class ActivitiesController < ApplicationController

  def index
    @activities = Activity.all

    respond_to do |format|
      format.html
      format.json { render json: @activities }
    end
  end

end
