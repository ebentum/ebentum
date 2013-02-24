class UsersController < ApplicationController

  before_filter :authenticate_user! # se van a poder ver perfiles de usuario sin estar dado de alta?, :except => [:show, :index]
  before_filter :search_users, :only => [:index]

  def search_users

    if params[:follower_id]

      current_user = User.find( params[:follower_id])
      @users = current_user.followed_users

    elsif params[:followed_id]

      current_user = User.find( params[:followed_id])
      @users = current_user.followers

    else

      @users = User.all

    end

  end

  def index

    if params[:no_layout]
      render_layout = false
    else
      render_layout = true
    end

    respond_to do |format|
      format.html { render :layout => render_layout} # index.html.erb
      format.json { render json: users }
    end
  end

  def show
    id = params[:id]

    @user = User.find(id)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: user }
    end
  end

end
