class ActivitiesController < ApplicationController

  before_filter :authenticate_user!

  def index
    #@activities = Activity.all
    @activities = current_user.activities
    #@activities = Activity.where(:receivers => User.last)
    #@activities = Activity.receivers.find(User.last)



    respond_to do |format|
      format.html
      format.json { render json: @activities }
    end
  end

end
