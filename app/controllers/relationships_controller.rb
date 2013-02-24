class RelationshipsController < ApplicationController

  def create
    # Follower user is always current user
    relationship = params[:relationship]
    followed_user = User.find(relationship[:followed_id])

    current_user.follow!(followed_user)

    respond_to do |format|
      format.html  { redirect_to(followed_user,
                    :notice => 'You are following this user now.') }
      format.json  { render :json => relationship,
                    :status => :created, :location =>relationship }
    end
  end

  def destroy

    relationship = Relationship.find(params[:id])

    unfollowed_user = User.find(relationship.followed_id)

    relationship.destroy

    respond_to do |format|
      format.html { redirect_to(unfollowed_user,
                  :notice => 'You are not following this user anymore.') }
      format.json { head :no_content }
    end

  end
end