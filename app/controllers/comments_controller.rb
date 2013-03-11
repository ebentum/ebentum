class CommentsController < ApplicationController

  def index
    @event    = Event.find(params[:event_id])
    @comments = @event.comment_threads
    
    respond_to do |format|
      format.html { render :layout => false }
      format.json { render json: @comments }
    end
  end

  def show
    @comment = Comment.find(params[:id])
    respond_to do |format|
      format.html { render :layout => false }
      format.json { render json: @comment }
    end
  end

  def create
    event   = Event.find(params[:event_id])
    comment = Comment.build_from(event, current_user.id, params[:comment_text])
    if comment.save
      render :json => comment
    end
  end

  def update
    comment = Comment.find(params[:id])
    if comment.body != params[:comment][:body]
      if comment.user_id == current_user.id
        comment.updated_at = Time.now
        if comment.update_attributes(params[:comment])
          comment['updated_at_formated'] = l(comment.updated_at, :format => :long)
          render :json => comment
        else
          render :json => false
        end  
      else
        render :json => false
      end
    else
      render :json => comment  
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    if comment.user_id == current_user.id
      comment.destroy
      render :json => true
    else
      render :json => false
    end
  end

end
