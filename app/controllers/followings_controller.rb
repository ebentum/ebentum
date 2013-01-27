class FollowingsController < ApplicationController


  def new
    @event = Event.new

    respond_to do |format|
      format.html { render :layout => 'modal_window' }
      format.json { render :json => @event }
    end
  end

  def create
    @following = Following.new(params[:following])
    following_user = User.find(@following.following_id)
    @following.user_id = current_user.id

    respond_to do |format|
      if @following.save
        format.html  { redirect_to(following_user,
                      :notice => 'You are following this user now.') }
        format.json  { render :json => @following,
                      :status => :created, :location => @following }
      else
        format.html  {  redirect_to(following_user,
                      :notice => 'Something wen''t wrong. Please try again.') }
        format.json  { render :json => @following.errors,
                      :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @following = Following.find(params[:id])
    unfollowed_user = User.find(@following.following_id)
    @following.destroy

    respond_to do |format|
      format.html { redirect_to(unfollowed_user,
                  :notice => 'You are not following this user anymore.') }
      format.json { head :no_content }
    end
  end
end