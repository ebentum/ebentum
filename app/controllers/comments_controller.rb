class CommentsController < ApplicationController

  def index
    event     = Event.find(params[:event_id])
    @comments = event.comment_threads
    
    respond_to do |format|
      format.html { render :layout => false }
      format.json { render json: @comments }
    end
  end

end
