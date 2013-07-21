class CommentsController < ApplicationController

  skip_before_filter :auth_user, :only => [:index]

  def index
    @event    = Event.find(params[:event_id])
    @page     = params[:page] || 1
    @comments = @event.comments.page(@page)
    
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
    event           = Event.find(params[:event_id])
    comment         = Comment.new
    comment.body    = params[:comment_text]
    comment.creator = current_user.id
    event.comments.push(comment)
    if event.save
      render :json => comment
    end
  end

  def update
    comment = Comment.find(params[:id])
    if comment.body != params[:comment][:body]
      if comment.creator.id == current_user.id
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
    if comment.creator.id == current_user.id
      comment.destroy
      render :json => true
    else
      render :json => false
    end
  end

end
